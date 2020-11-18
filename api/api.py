from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional
from models import Initiative, PersonalDonationLinkRequest, VolunteerEvent, VolunteerRole

app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/api/", response_model=str)
def root() -> str:
    return "Hello from the Humanity Forward Volunteer Portal Dev Team"

@app.get("/api/volunteer_roles/", response_model=List[VolunteerRole])
def get_all_volunteer_roles() -> List[VolunteerRole]:
    return VolunteerRole.all

@app.get("/api/volunteer_roles/{role_external_id}", response_model=VolunteerRole)
def get_volunteer_role_by_external_id(role_external_id) -> Optional[VolunteerRole]:
    return VolunteerRole.find(role_external_id)

@app.get("/api/volunteer_events/", response_model=List[VolunteerEvent])
def get_all_volunteer_events() -> List[VolunteerEvent]:
    return VolunteerEvent.all

@app.get("/api/volunteer_events/{event_external_id}", response_model=VolunteerEvent)
def get_volunteer_event_by_external_id(event_external_id) -> Optional[VolunteerEvent]:
    return VolunteerEvent.find(event_external_id)

@app.get("/api/initiatives/", response_model=List[Initiative])
def get_all_initiatives() -> List[Initiative]:
    return Initiative.all

@app.get("/api/initiatives/{initiative_external_id}", response_model=Initiative)
def get_initiative_by_external_id(initiative_external_id) -> List[Initiative]:
    return Initiative.find(initiative_external_id)

@app.post("/api/donation_link_requests/")
def request_personal_donation_link(link_request: PersonalDonationLinkRequest) -> PersonalDonationLinkRequest:
    return PersonalDonationLinkRequest.insert(link_request)
