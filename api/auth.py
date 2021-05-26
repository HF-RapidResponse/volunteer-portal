from typing import Dict
from enum import Enum
import logging

from fastapi import APIRouter, Request, Depends, FastAPI, HTTPException
import starlette.config
from authlib.integrations.starlette_client import OAuth, OAuthError
from fastapi import HTTPException
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi_jwt_auth import AuthJWT

from settings import Config, Session, get_db
from models import Initiative, VolunteerEvent, VolunteerRole, Account
from models import PersonalIdentifier, VerificationToken, IdentifierType, NotificationChannel, EmailIdentifier
from schemas import AccountBasicLoginSchema, AccountPasswordSchema, AccountWithSettings, AccountResponseSchema
from schemas import IdentifierVerificationStart, IdentifierVerificationFinishResponse
from security import encrypt_password, check_encrypted_password
from sqlalchemy.orm import lazyload
from account_api import create_access_and_refresh_tokens, create_account_settings
import notifications_manager
from identifiers_helper import IdentifierState, get_or_create_identifier
from notifications_api import create_verification_registration_email
from helpers import row2dict

router = APIRouter()
logging.getLogger(__name__).setLevel(logging.INFO)

auth_secret = Config['auth']['jwt']['secret']


@AuthJWT.load_config
def get_config():
    return [
        ('authjwt_secret_key', auth_secret),
        ('authjwt_token_location', {"cookies"}),
        ('authjwt_cookie_csrf_protect', False)
    ]


class OAuthProvider(Enum):
    GOOGLE = 'google'
    GITHUB = 'github'


oauth = OAuth()
if OAuthProvider.GOOGLE.value in Config['auth']:
    oauth.register(
        name='google',
        client_id=Config['auth']['google']['client_id'],
        client_secret=Config['auth']['google']['client_secret'],
        server_metadata_url='https://accounts.google.com/.well-known/openid-configuration',
        client_kwargs={
            'scope': 'openid email profile'
        }
    )
if OAuthProvider.GITHUB.value in Config['auth']:
    oauth.register(
        name='github',
        client_id=Config['auth']['github']['client_id'],
        client_secret=Config['auth']['github']['client_secret'],
        access_token_url='https://github.com/login/oauth/access_token',
        access_token_params=None,
        authorize_url='https://github.com/login/oauth/authorize',
        authorize_params=None,
        api_base_url='https://api.github.com/',
        client_kwargs={'scope': 'user:email'},
    )


@router.get("/login")
async def login(request: Request, provider: OAuthProvider):
    if provider is OAuthProvider.GOOGLE:
        redirect_uri = request.url_for('authorize_google')
        return await oauth.google.authorize_redirect(request, redirect_uri)
    elif provider is OAuthProvider.GITHUB:
        redirect_uri = request.url_for('authorize_github')
        return await oauth.github.authorize_redirect(request, redirect_uri)


@router.get("/auth/google")
async def authorize_google(request: Request, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    try:
        token = await oauth.google.authorize_access_token(request)
    except OAuthError as error:
        return HTMLResponse(f'<h1>{error.error}</h1>')
    user = await oauth.google.parse_id_token(request, token)

    account = oauth_login_or_creation(id_type=IdentifierType.GOOGLE_ID,
                                      identifier_value=user.email,
                                      identifier_class=EmailIdentifier,
                                      username=user.email.split('@')[0],
                                      first_name=user.given_name,
                                      last_name=user.family_name,
                                      profile_pic=user.picture,
                                      db=db)
    return create_token_for_user(Authorize, str(account.uuid))

def oauth_login_or_creation(id_type,
                            identifier_value,
                            username,
                            first_name,
                            last_name,
                            profile_pic,
                            db,
                            identifier_class=PersonalIdentifier,
                            city=None,
                            state=None):
    id_state, identifier = get_or_create_identifier(id_type,
                                                    identifier_value, db,
                                                    identifier_class)

    if id_state is IdentifierState.NONE_MATCHING \
       or id_state is IdentifierState.NO_ACCOUNT_IS_VERIFIED \
       or id_state is IdentifierState.NO_ACCOUNT_NOT_VERIFIED:
        logging.info('Creating a new user object for first-time login')

        identifier.verified = True
        primary_email = identifier if isinstance(identifier, EmailIdentifier) else None
        new_account = Account(
            username=username,
            first_name=first_name,
            last_name=last_name,
            profile_pic=profile_pic,
            primary_email_identifier=primary_email,
            city=city,
            state=state)
        db.add(new_account)
        db.commit()
        db.refresh(new_account)
        identifier.account_uuid = new_account.uuid
        identifier.verified = True
        create_account_settings(new_account.uuid, db)
        account = new_account
    else:
        account = identifier.account
    return account


@router.post("/create_token")
def get_token_from_email(account: AccountBasicLoginSchema, Authorize: AuthJWT = Depends()):
    access_token = Authorize.create_access_token(subject=str(account.email))
    Authorize.set_access_cookies(access_token)


@router.post("/verify_password")
def verify_password(payload: AccountPasswordSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    existing_acct = db.query(Account).filter_by(uuid=payload.uuid).first()
    password_valid = check_encrypted_password(
        payload.old_password, existing_acct.password)
    if password_valid is True:
        return True
    else:
        raise HTTPException(
            status_code=403, detail=f"Password is incorrect")


@router.post("/auth/basic", response_model=AccountResponseSchema)
def authorize_basic(account: AccountBasicLoginSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    identifier = db.query(PersonalIdentifier).filter_by(value=account.email)\
                                             .filter_by(type=IdentifierType.EMAIL)\
                                             .first()
    existing_acct = identifier.account
    if existing_acct is None:
        raise HTTPException(
            status_code=403, detail=f"E-mail or password is invalid!")
    verified_pw = check_encrypted_password(
        account.password, existing_acct.password)
    if verified_pw is False:
        raise HTTPException(
            status_code=403, detail=f"E-mail or password is invalid!")
    if identifier.verified is False:
        raise HTTPException(
            status_code=403, detail=f"Account has not been verified. Please check your e-mail."
        )
    create_access_and_refresh_tokens(str(existing_acct.uuid), Authorize)
    return existing_acct


@router.post('/refresh')
def refresh(Authorize: AuthJWT = Depends()):
    Authorize.jwt_refresh_token_required()
    current_token = Authorize.get_jwt_subject()
    new_access_token = Authorize.create_access_token(
        subject=str(current_token))
    # Set the JWT cookies in the response
    Authorize.set_access_cookies(new_access_token)
    return {"msg": "The token has been refresh"}


@router.get("/initiative_map/default")
def populate_initiative_map(db: Session = Depends(get_db)) -> Dict:
    initiatives = db.query(Initiative).options(
        lazyload(Initiative.roles_rel)).all()
    result = {}
    if initiatives is not None:
        for item in initiatives:
            result[item] = False
    return result


@router.get("/auth/github")
async def authorize_github(request: Request, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    try:
        token = await oauth.github.authorize_access_token(request)
    except OAuthError as error:
        return HTMLResponse(f'<h1>{error.error}</h1>')
    resp = await oauth.github.get('user', token=token)
    user = resp.json()
    email_to_use = user['email'] or user['login'] + '@fakegithubemail.com'

    account = oauth_login_or_creation(
        id_type=IdentifierType.GITHUB_ID,
        identifier_value=email_to_use,
        identifier_class=EmailIdentifier,
        username=user['login'],
        first_name=user['name'],
        last_name='no last name',
        profile_pic=user['avatar_url'],
        city=None if user['location'] is None else user['location'].split(', ')[
            0],
        state=None if user['location'] is None else user['location'].split(', ')[
            1],
        db=db)
    return create_token_for_user(Authorize, str(account.uuid))


@router.delete("/logout")
def logout(Authorize: AuthJWT = Depends()):
    Authorize.jwt_required()

    Authorize.unset_jwt_cookies()
    return {"msg": "Successfully logged out"}


def create_token_for_user(Authorize: AuthJWT, user_id: str) -> Dict:
    response = RedirectResponse(
        f'{Config["routes"]["client"]}/login_callback?user_id={user_id}')
    access_token = Authorize.create_access_token(subject=user_id)
    refresh_token = Authorize.create_refresh_token(subject=user_id)
    Authorize.set_access_cookies(access_token, response)
    Authorize.set_refresh_cookies(refresh_token, response)
    return response

def get_logged_in_user(Authorize: AuthJWT, db: Session) -> Account:
    account_uuid = Authorize.get_jwt_subject()
    return db.query(Account).filter(Account.uuid==account_uuid).first() if account_uuid else None

def get_verification_url_for_token(token: VerificationToken) -> str:
    # WARNING: never send this directly to the front-end
    # only send this to the user through another medium to be verified by our client/api

    return f'{Config["routes"]["client"]}/verify_token?token={token.uuid}&otp={token.otp}'


@router.post("/verify_identifier/start")
def begin_identifer_verification(request: IdentifierVerificationStart, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_optional()
    account = get_logged_in_user(Authorize, db)

    if not account and request.account_uuid:
        account = db.query(Account).filter_by(uuid=request.account_uuid).first()

    id_state, identifier = get_or_create_identifier(request.type, request.identifier, db)

    has_account = identifier.account_uuid is not None
    if identifier.verified:
        raise HTTPException(status_code=403, detail='The provided personal identifier is already verified ')

    if has_account and account and account.uuid != identifier.account_uuid:
        raise HTTPException(status_code=403, detail='The provided personal identifier is already verified and associated with a different account')
    elif account and not identifier.account_uuid:
        # associate the identifier to the logged in account
        identifier.account_uuid = account.uuid

    identifier.account = account
    token = VerificationToken()
    token.personal_identifier = identifier
    db.add(token)
    db.commit()

    if identifier.type is IdentifierType.EMAIL:
        url = get_verification_url_for_token(token)
        name = identifier.account.first_name if has_account else "friend"
        message = create_verification_registration_email(name, url, db)
        notifications_manager.send_notification(
            identifier.value, message, NotificationChannel.EMAIL,
            title=f'Please verify your email with {Config["public_facing_org_name"]}')

    return {'verification_token_uuid': token.uuid}

@router.get("/verify_token/finish", response_model=IdentifierVerificationFinishResponse)
def finish_token_verification(token: str, otp: str, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_optional()
    verification_token = db.query(VerificationToken).filter(VerificationToken.uuid == token).first()
    identifier = verification_token.personal_identifier

    if not verification_token:
        raise HTTPException(status_code=422, detail='No verification token exists for the provided verification_token_uuid')

    try:
        # This marks any associated identifiers, subscriptions, etc verified
        verified = verification_token.verify(otp, db)

        db.flush()
        db.commit()
    except ValueError as e:
        logging.error(e)
        raise HTTPException(status_code=422, detail='The provided token and OTP could not be verified')

    if not verified:
        logging.error(f'Attempted verification of token {verification_token.uuid} with incorrect OTP')
        raise HTTPException(status_code=422, detail='The provided token and OTP could not be verified')
    elif identifier:
        account = identifier.account
        if account is not None:
            create_access_and_refresh_tokens(
                str(account.uuid), Authorize)
            db.flush()
            db.commit()
            return {'account': account}
    return {'msg': 'The provided token\'s associated values have been verified'}
