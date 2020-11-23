from fastapi import Depends, FastAPI
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional
# from models import Initiative, PersonalDonationLinkRequest, VolunteerEvent, VolunteerRole
from models import Initiative, VolunteerEvent, VolunteerRole
from schemas import VolunteerRoleSchema
from settings import Session

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
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

@app.get("/api/volunteer_roles/", response_model=List[VolunteerRoleSchema])
def get_all_volunteer_roles(db: Session = Depends(get_db)) -> List[VolunteerRoleSchema]:
    return db.query(VolunteerRole).all()

@app.get("/api/volunteer_roles/{role_external_id}", response_model=VolunteerRoleSchema)
def get_volunteer_role_by_external_id(role_external_id, db: Session = Depends(get_db)) -> Optional[VolunteerRoleSchema]:
    return db.query(VolunteerRole).filter_by(role_external_id=role_external_id).first()

# @app.get("/api/volunteer_events/", response_model=List[VolunteerEvent])
# def get_all_volunteer_events() -> List[VolunteerEvent]:
#     return []
#
# @app.get("/api/volunteer_events/{event_external_id}", response_model=VolunteerEvent)
# def get_volunteer_event_by_external_id(event_external_id) -> Optional[VolunteerEvent]:
#     return {}
#
# @app.get("/api/initiatives/", response_model=List[Initiative])
# def get_all_initiatives() -> List[Initiative]:
#     return []
#
# @app.get("/api/initiatives/{initiative_external_id}", response_model=Initiative)
# def get_initiative_by_external_id(initiative_external_id) -> List[Initiative]:
#     return {}
#
# @app.post("/api/donation_link_requests/")
# def request_personal_donation_link(link_request: PersonalDonationLinkRequest) -> PersonalDonationLinkRequest:
#     return {}
