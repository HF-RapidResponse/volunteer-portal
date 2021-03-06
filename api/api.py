from fastapi import Depends, FastAPI, Form, Request, HTTPException, Header
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional, Text, Union, Mapping, Any
from models import Initiative, VolunteerEvent, VolunteerRole, DonationEmail, Account
from schemas import (NestedInitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema,
                     DonationEmailSchema, AccountRequestSchema, AccountResponseSchema, PartialAccountSchema)
from sqlalchemy.orm import lazyload
from starlette.middleware.sessions import SessionMiddleware
from fastapi.responses import JSONResponse
from fastapi_jwt_auth.exceptions import AuthJWTException
from fastapi.encoders import jsonable_encoder
import auth
from settings import Config, Session, get_db
import logging
from uuid import uuid4, UUID
from fastapi_jwt_auth import AuthJWT
import external_data_sync
from security import encrypt_password, check_encrypted_password

app = FastAPI()

origins = [Config['routes']['client']]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.add_middleware(SessionMiddleware,
                   secret_key=Config['auth']['jwt']['secret'])
app.include_router(
    auth.router,
    prefix='/api'
)

CLIENT_ID = "899853639312-rluooarpraulr242vuvfqejefmg1ii8d.apps.googleusercontent.com"


@app.exception_handler(AuthJWTException)
def authjwt_exception_handler(request: Request, exc: AuthJWTException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.message}
    )


app.include_router(
    external_data_sync.router,
    prefix='/api'
)

logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)


@app.get("/api/", response_model=str)
def root() -> str:
    return "Hello from the Humanity Forward Volunteer Portal Dev Team"


@app.get("/api/volunteer_roles/", response_model=List[VolunteerRoleSchema])
def get_all_volunteer_roles(db: Session = Depends(get_db)) -> List[VolunteerRoleSchema]:
    return db.query(VolunteerRole).all()


@app.get("/api/volunteer_roles/{role_external_id}", response_model=VolunteerRoleSchema)
def get_volunteer_role_by_external_id(role_external_id, db: Session = Depends(get_db)) -> Optional[VolunteerRoleSchema]:
    return db.query(VolunteerRole).filter_by(external_id=role_external_id).first()


@app.get("/api/volunteer_events/", response_model=List[VolunteerEventSchema])
def get_all_volunteer_events(db: Session = Depends(get_db)) -> List[VolunteerEventSchema]:
    return db.query(VolunteerEvent).all()


@app.get("/api/volunteer_events/{external_id}", response_model=VolunteerEventSchema)
def get_volunteer_event_by_external_id(external_id, db: Session = Depends(get_db)) -> Optional[VolunteerEventSchema]:
    return db.query(VolunteerEvent).filter_by(external_id=external_id).first()


@app.get("/api/initiatives/", response_model=List[NestedInitiativeSchema])
def get_all_initiatives(db: Session = Depends(get_db)) -> List[NestedInitiativeSchema]:
    return db.query(Initiative).options(lazyload(Initiative.roles_rel)).all()


@app.get("/api/initiatives/{initiative_external_id}", response_model=NestedInitiativeSchema)
def get_initiative_by_external_id(initiative_external_id, db: Session = Depends(get_db)) -> List[NestedInitiativeSchema]:
    return db.query(Initiative).filter_by(external_id=initiative_external_id).first()


@app.post("/api/donation_link_requests/", response_model=DonationEmailSchema)
def create_donation_link_request(donationEmail: DonationEmailSchema, db: Session = Depends(get_db)) -> DonationEmailSchema:
    db.add(DonationEmail(email=donationEmail.email))
    db.commit()
    return donationEmail


@app.get("/api/accounts/", response_model=List[AccountResponseSchema])
def get_all_accounts(db: Session = Depends(get_db)):
    return db.query(Account).all()


@app.get("/api/accounts/{uuid}", response_model=AccountResponseSchema)
def get_account_by_uuid(uuid, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    return db.query(Account).filter_by(uuid=uuid).first()


@app.get("/api/accounts/email/{email}", response_model=AccountResponseSchema)
def get_account_by_email(email, db: Session = Depends(get_db)):
    return db.query(Account).filter_by(email=email).first()


@app.post("/api/accounts/", response_model=AccountResponseSchema, status_code=201)
def create_account(account: AccountRequestSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    existing_acct = db.query(Account).filter_by(email=account.email).first()
    if existing_acct is not None:
        raise HTTPException(
            status_code=400, detail=f"An account with the email address {account.email} already exists")
    if account.password is not None:
        account.password = encrypt_password(account.password)

    account = Account(**account.dict())
    db.add(account)
    db.commit()
    # db.refresh(account)
    create_access_and_refresh_tokens(str(account.uuid), Authorize)
    return account


def create_access_and_refresh_tokens(user_id: str, Authorize: AuthJWT):
    try:
        access_token = Authorize.create_access_token(subject=user_id)
        Authorize.set_access_cookies(access_token)
        refresh_token = Authorize.create_refresh_token(subject=user_id)
        Authorize.set_refresh_cookies(refresh_token)
    except:
        raise HTTPException(
            status_code=500, detail=f"Error while trying to create and refresh tokens")


@app.put("/api/accounts/{uuid}", response_model=AccountResponseSchema)
def put_update_account(uuid, account: AccountRequestSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    updated_acct = Account(uuid=uuid, **account.dict())
    db.merge(updated_acct)
    db.commit()
    return updated_acct


@app.patch("/api/accounts/{uuid}", response_model=AccountResponseSchema)
def update_password(uuid, partial_account: PartialAccountSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    account = db.query(Account).filter_by(uuid=uuid).first()
    if partial_account.password is not None:
        account.password = encrypt_password(partial_account.password)
    db.merge(account)
    db.commit()
    db.refresh(account)
    return account


@ app.delete("/api/accounts/{uuid}", status_code=204)
def delete_account(uuid, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    # Authorize.jwt_required()
    acct_to_delete = db.query(Account).filter_by(uuid=uuid).first()
    if acct_to_delete is None:
        raise HTTPException(status_code=404,
                            detail=f"Account with UUID {uuid} not found")
    db.delete(acct_to_delete)
    db.commit()
