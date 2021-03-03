from typing import Dict
from enum import Enum
import logging

from fastapi import APIRouter, Request, Depends, FastAPI, HTTPException
import starlette.config
from authlib.integrations.starlette_client import OAuth, OAuthError
from fastapi import HTTPException
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi_jwt_auth import AuthJWT
from sqlalchemy import and_

from settings import Config, Session, get_db
from models import Initiative, VolunteerEvent, VolunteerRole, Account
from models import  PersonalIdentifier, VerificationToken, IdentifierType, NotificationChannel
from schemas import AccountBasicLoginSchema, AccountPasswordSchema
from schemas import IdentifierVerificationStart, IdentifierVerificationFinish
from security import encrypt_password, check_encrypted_password
from sqlalchemy.orm import lazyload
from account_api import create_access_and_refresh_tokens, create_account_settings
import notifications_manager

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
    account = db.query(Account).filter_by(email=user.email).first()
    if account is None:
        logging.warning('Creating a new user object for first-time login')
        new_account = Account(
            email=user.email,
            username=user.email.split('@')[0],
            first_name=user.given_name,
            last_name=user.family_name,
            oauth='google',
            profile_pic=user.picture,
            is_verified=True,
        )
        db.add(new_account)
        db.commit()
        db.refresh(new_account)
        create_account_settings(new_account.uuid, db)
        account = new_account
    return create_token_for_user(Authorize, str(account.uuid))


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


@router.post("/auth/basic")
def authorize_basic(account: AccountBasicLoginSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    existing_acct = db.query(Account).filter_by(email=account.email).first()
    if existing_acct is None:
        raise HTTPException(
            status_code=403, detail=f"E-mail or password is invalid!")
    verified_pw = check_encrypted_password(
        account.password, existing_acct.password)
    if verified_pw is False:
        raise HTTPException(
            status_code=403, detail=f"E-mail or password is invalid!")
    if existing_acct.is_verified is False:
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
    account = db.query(Account).filter_by(
        email=email_to_use).first()

    if account is None:
        new_account = Account(
            email=email_to_use,
            username=user['login'],
            first_name=user['name'],
            last_name='no last name',
            oauth='github',
            profile_pic=user['avatar_url'],
            city=None if user['location'] is None else user['location'].split(', ')[
                0],
            state=None if user['location'] is None else user['location'].split(', ')[
                1],
            is_verified=True
        )
        db.add(new_account)
        db.commit()
        db.refresh(new_account)
        create_account_settings(new_account.uuid, db)
        account = new_account
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

    return f'{Config["routes"]["client"]}/verify_identifier?token={token.uuid}&otp={token.otp}'


@router.post("/verify_identifier/start")
def begin_identifer_verification(request: IdentifierVerificationStart, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_optional()
    account = get_logged_in_user(Authorize, db)

    existing_identifier = db.query(PersonalIdentifier).filter(and_(PersonalIdentifier.type==request.type, PersonalIdentifier.value==request.identifier)).first()

    # this would be too much information to expose via a public API; you could use this to determine who our users are
    if existing_identifier and existing_identifier.verified and existing_identifier.account and not account:
        raise HTTPException(status_code=403, detail='The provided personal identifier is already verified and associated to an account')
    if existing_identifier and existing_identifier.verified and existing_identifier.account and account and not existing_identifier.account_uuid == account.uuid:
        raise HTTPException(status_code=403, detail='The provided personal identifier is already verified and associated with a different account')
    if existing_identifier and existing_identifier.verified and not existing_identifier.account and account:
        # currently associating an identifier with an account during this request (so we can enforce that account's ownership on finish)
        # there's a potential security concern here with accounts "adopting" identifiers they have no ownership of
        # may in the future need some intermediate state for "account association is pending identifier verification while logged in"
        pass

    if existing_identifier:
        identifier = existing_identifier
    else:
        new_identifier = PersonalIdentifier(type=request.type, value=request.identifier)
        db.add(new_identifier)
        identifier = new_identifier

    identifier.account = account
    token = VerificationToken()
    token.personal_identifier = identifier
    db.add(token)
    db.commit()

    if identifier.type is IdentifierType.EMAIL:
        message = f'Please click <a href={get_verification_url_for_token(token)}>this link</a> to verify your email'
        notifications_manager.send_notification(identifier.value, message, NotificationChannel.EMAIL, title=f'Please verify your email with {Config["public_facing_org_name"]}')

    return {'verification_token_uuid': token.uuid}

@router.post("/verify_identifier/finish")
def finish_identifier_verification(request: IdentifierVerificationFinish, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_optional()
    account = get_logged_in_user(Authorize, db)

    verification_token = db.query(VerificationToken).filter(VerificationToken.uuid==request.verification_token_uuid).first()

    if not verification_token:
        raise HTTPException(status_code=422, detail='No verification token exists for the provided verification_token_uuid')

    if verification_token.personal_identifier and verification_token.personal_identifier.account and account and not verification_token.personal_identifier.account == account.uuid:
        raise HTTPException(status_code=403, detail='The provided token\'s personal identifier can only be verified by the associated account')

    try:
        verified = verification_token.verify(request.otp, db)
    except ValueError as e:
        logging.error(e)
        raise HTTPException(status_code=422, detail='The provided token and OTP could not be verified')

    if not verified:
        logging.error(f'Attempted verification of token {verification_token.uuid} with incorrect OTP')
        raise HTTPException(status_code=422, detail='The provided token and OTP could not be verified')
    else:
        return {'msg': 'The provided token\'s personal identifier has been verified'}
