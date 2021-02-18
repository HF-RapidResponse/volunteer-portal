from fastapi import Depends, FastAPI, Form, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional, Text
from models import Initiative, VolunteerEvent, VolunteerRole, DonationEmail, Account
from schemas import NestedInitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema, DonationEmailSchema, AccountRequestSchema, AccountResponseSchema
from sqlalchemy.orm import lazyload
from starlette.middleware.sessions import SessionMiddleware
from fastapi.responses import JSONResponse
from fastapi_jwt_auth.exceptions import AuthJWTException
import auth
from settings import Config, Session, get_db
import logging
from uuid import uuid4, UUID

import external_data_sync

app = FastAPI()

origins = ['*']

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
def get_all_accounts(db: Session = Depends(get_db)) -> List[AccountRequestSchema]:
    return db.query(Account).all()


@app.get("/api/accounts/{uuid}", response_model=AccountResponseSchema)
def get_account_by_uuid(uuid, db: Session = Depends(get_db)) -> Optional[AccountRequestSchema]:
    return db.query(Account).filter_by(uuid=uuid).first()


@app.get("/api/accounts/{email}", response_model=AccountResponseSchema)
def get_account_by_email(email, db: Session = Depends(get_db)) -> Optional[AccountRequestSchema]:
    return db.query(Account).filter_by(email=email).first()


@app.post("/api/accounts/", response_model=AccountResponseSchema, status_code=201)
def create_account(account: AccountRequestSchema, db: Session = Depends(get_db)):
    acct_uuid = uuid4()
    db.add(Account(uuid=acct_uuid, email=account.email, username=account.username, first_name=account.first_name,
                   last_name=account.last_name, city=account.city, state=account.state, roles=account.roles, initiative_map=account.initiative_map))
    db.commit()
    return db.query(Account).filter_by(uuid=acct_uuid).first()


@app.delete("/api/accounts/{uuid}", status_code=204)
def delete_account(uuid, db: Session = Depends(get_db)):
    acct_to_delete = db.query(Account).filter_by(uuid=uuid).first()
    if acct_to_delete is None:
        raise HTTPException(status_code=404,
                            detail=f"Account with UUID {uuid} not found")
    db.delete(acct_to_delete)
    db.commit()


@ app.get("/api/uuid", response_model=UUID)
def generate_uuid() -> UUID:
    return uuid4()
