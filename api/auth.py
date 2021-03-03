from typing import Dict
from enum import Enum

from fastapi import APIRouter, Request, Depends
import starlette.config
from authlib.integrations.starlette_client import OAuth, OAuthError
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi_jwt_auth import AuthJWT

from settings import Config

router = APIRouter()

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

@router.get("/profile")
def get_profile(Authorize: AuthJWT = Depends()) -> Dict:
    Authorize.jwt_required()

    current_user = Authorize.get_jwt_subject()
    return {"user": current_user}

@router.get("/login")
async def login(request: Request, provider: OAuthProvider):
    if provider is OAuthProvider.GOOGLE:
        redirect_uri = request.url_for('authorize_google')
        return await oauth.google.authorize_redirect(request, redirect_uri)
    elif provider is OAuthProvider.GITHUB:
        redirect_uri = request.url_for('authorize_github')
        return await oauth.github.authorize_redirect(request, redirect_uri)

@router.get("/auth/google")
async def authorize_google(request: Request, Authorize: AuthJWT = Depends()):
    try:
        token = await oauth.google.authorize_access_token(request)
    except OAuthError as error:
        return HTMLResponse(f'<h1>{error.error}</h1>')
    user = await oauth.google.parse_id_token(request, token)
    return create_token_for_user(Authorize, user.email)

@router.get("/auth/github")
async def authorize_github(request: Request, Authorize: AuthJWT = Depends()):
    try:
        token = await oauth.github.authorize_access_token(request)
    except OAuthError as error:
        return HTMLResponse(f'<h1>{error.error}</h1>')
    resp = await oauth.github.get('user', token=token)
    user = resp.json()
    return create_token_for_user(Authorize, user['login'])

@router.delete("/logout")
def logout(Authorize: AuthJWT = Depends()):
    Authorize.jwt_required()

    Authorize.unset_jwt_cookies()
    return {"msg":"Successfully logged out"}

def create_token_for_user(Authorize: AuthJWT, user_id: str) -> Dict:
    access_token = Authorize.create_access_token(subject=user_id)
    # refresh_token = Authorize.create_refresh_token(subject=user_id)
    response = RedirectResponse(f'{Config["routes"]["client"]}/auth_callback')
    Authorize.set_access_cookies(access_token, response)
    # Authorize.set_refresh_cookies(refresh_token)
    return response

# @router.post("/validate_identifier/start")
# def begin_identifer_validation(request: Request, Authorize: AuthJWT, )