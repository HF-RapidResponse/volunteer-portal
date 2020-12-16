from fastapi import Depends, FastAPI
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional
<<<<<<< HEAD
from models import Initiative, VolunteerEvent, VolunteerRole
from schemas import NestedInitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema
from sqlalchemy.orm import lazyload
=======
from models import Initiative, VolunteerEvent, VolunteerRole, PersonalDonationLinkRequest
from schemas import NestedInitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema, PersonalDonationLinkRequestSchema
from sqlalchemy.orm import lazyload  # type: ignore
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
from settings import Session

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

import logging
logging.basicConfig()
<<<<<<< HEAD
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)
=======
logging.getLogger('sqlalchemy.engine').setLevel(logging.WARNING)
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100

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
<<<<<<< HEAD
=======
    
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
    return db.query(Initiative).options(lazyload(Initiative.roles_rel)).all()

@app.get("/api/initiatives/{initiative_external_id}", response_model=NestedInitiativeSchema)
def get_initiative_by_external_id(initiative_external_id, db: Session = Depends(get_db)) -> List[NestedInitiativeSchema]:
    return db.query(Initiative).filter_by(initiative_external_id=initiative_external_id).first()

<<<<<<< HEAD
# @app.post("/api/donation_link_requests/")
# def request_personal_donation_link(link_request: PersonalDonationLinkRequest) -> PersonalDonationLinkRequest:
#     return {}
=======
@app.post("/api/donation_link_requests/")
def request_personal_donation_link(link_request: PersonalDonationLinkRequestSchema,
                                   db: Session = Depends(get_db)):
    request_model = PersonalDonationLinkRequest(**link_request.dict())
    db.add(request_model)
    db.commit()
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
