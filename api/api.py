from fastapi import Depends, FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import HTMLResponse, RedirectResponse
from typing import List, Optional, Dict
from models import Initiative, VolunteerEvent, VolunteerRole, PersonalDonationLinkRequest
from schemas import NestedInitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema, PersonalDonationLinkRequestSchema
from sqlalchemy.orm import lazyload  # type: ignore
from starlette.middleware.sessions import SessionMiddleware
import starlette.config
from authlib.integrations.starlette_client import OAuth, OAuthError

from settings import Config, Session

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(SessionMiddleware, secret_key="!secret")

import logging
logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.WARNING)

# this expects a .secrets file that looks like this: https://github.com/authlib/demo-oauth-client/blob/master/fastapi-google-login/.env.sample
auth_config = starlette.config.Config('.secrets')
CONF_URL = 'https://accounts.google.com/.well-known/openid-configuration'
oauth = OAuth(auth_config)
oauth.register(
    name='google',
    server_metadata_url=CONF_URL,
    client_kwargs={
        'scope': 'openid email profile'
    }
)

# Dependency
def get_db():
    try:
        db = Session()
        yield db
    finally:
        db.close()

@app.get("/api/", response_model=str)
def root() -> str:
    return "Hello from the Humanity Forward Volunteer Portal Dev Team"

@app.get("/api/profile/")
def get_profile(request: Request) -> Dict:
    user = request.session.get('user')
    return user if user else {'error': 'no user'}

@app.get("/api/login")
async def login(request: Request):
    redirect_uri = request.url_for('auth')
    return await oauth.google.authorize_redirect(request, redirect_uri)

@app.get("/api/auth")
async def auth(request: Request):
    try:
        token = await oauth.google.authorize_access_token(request)
    except OAuthError as error:
        return HTMLResponse(f'<h1>{error.error}</h1>')
    user = await oauth.google.parse_id_token(request, token)
    request.session['user'] = dict(user)
    return RedirectResponse(url='/api/profile')

@app.get("/api/logout")
async def logout(request: Request):
    request.session.pop('user', None)
    return RedirectResponse(url='/api/profile')

@app.get("/api/volunteer_roles/", response_model=List[VolunteerRoleSchema])
def get_all_volunteer_roles(db: Session = Depends(get_db)) -> List[VolunteerRoleSchema]:
    return db.query(VolunteerRole).all()

@app.get("/api/volunteer_roles/{role_external_id}", response_model=VolunteerRoleSchema)
def get_volunteer_role_by_external_id(role_external_id, db: Session = Depends(get_db)) -> Optional[VolunteerRoleSchema]:
    return db.query(VolunteerRole).filter_by(role_external_id=role_external_id).first()

@app.get("/api/volunteer_events/", response_model=List[VolunteerEventSchema])
def get_all_volunteer_events(db: Session = Depends(get_db)) -> List[VolunteerEventSchema]:
    return db.query(VolunteerEvent).all()

@app.get("/api/volunteer_events/{event_external_id}", response_model=VolunteerEventSchema)
def get_volunteer_event_by_external_id(event_external_id, db: Session = Depends(get_db)) -> Optional[VolunteerEventSchema]:
    return db.query(VolunteerEvent).filter_by(event_external_id=event_external_id).first()

@app.get("/api/initiatives/", response_model=List[NestedInitiativeSchema])
def get_all_initiatives(db: Session = Depends(get_db)) -> List[NestedInitiativeSchema]:
    
    return db.query(Initiative).options(lazyload(Initiative.roles_rel)).all()

@app.get("/api/initiatives/{initiative_external_id}", response_model=NestedInitiativeSchema)
def get_initiative_by_external_id(initiative_external_id, db: Session = Depends(get_db)) -> List[NestedInitiativeSchema]:
    return db.query(Initiative).filter_by(initiative_external_id=initiative_external_id).first()

@app.post("/api/donation_link_requests/")
def request_personal_donation_link(link_request: PersonalDonationLinkRequestSchema,
                                   db: Session = Depends(get_db)):
    request_model = PersonalDonationLinkRequest(**link_request.dict())
    db.add(request_model)
    db.commit()
