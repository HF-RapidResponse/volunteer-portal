from pydantic import BaseModel, EmailStr, validator
from typing import Optional, Union, List, Type, Any
from enum import Enum
from uuid import UUID, uuid4
from datetime import datetime, timezone

from self_hydrating_model import SelfHydratingModel

Url = str
MarkdownText = str

NowUtc = lambda: datetime.now(tz=timezone.utc)

def generate_placeholder_image() -> Url:
    return 'https://actblue-indigo-uploads.s3.amazonaws.com/uploads/list-editor/brandings/65454/header/image_url/f7edc334-2217-43b9-b707-5b7eaed92c1b-logo_stacked.svg'

class Person(BaseModel):
    name: str

class Priority(Enum):
    TOP_PRIORITY = 'Top Priority'
    HIGH = 'high'
    MEDIUM = 'medium'
    LOW = 'low'
    COULD_BE_NICE = 'Could Be Nice'
    NONE = None

class RoleType(Enum):
    REQUIRES_APPLICATION = 'Requires Application'
    OPEN_TO_ALL = 'Open to All'
    
class VolunteerRole(SelfHydratingModel):
    role_uuid: UUID = uuid4()
    role_external_id: str
    name: str
    hero_image_url: Url = generate_placeholder_image()
    signup_url: Optional[Url]
    details_url: Optional[Url]
    priority: Priority = Priority.LOW
    role_type: RoleType
    point_of_contact: Optional[Person]
    num_openings: Optional[int] = 1
    min_time_commitment: Optional[int]
    max_time_commitment: Optional[int]
    overview: Optional[MarkdownText]
    benefits: Optional[MarkdownText]
    responsibilites: Optional[MarkdownText]
    qualifications: Optional[MarkdownText]

    def __init__(self, **kwargs):
        fields_to_self_hydrate = {
            'point_of_contact': Person
        }

        super().__init__(fields_to_self_hydrate=fields_to_self_hydrate, **kwargs)

class VolunteerEvent(SelfHydratingModel):
    event_uuid: UUID = uuid4()
    event_external_id: str
    name: str
    hero_image_url: Url = generate_placeholder_image()
    signup_url: Url
    details_url: Optional[Url]
    start_datetime: datetime
    end_datetime: Optional[datetime]
    description: Optional[MarkdownText]
    point_of_contact: Optional[Person]

    def __init__(self, **kwargs):
        fields_to_self_hydrate = {
            'point_of_contact': Person
        }

        super().__init__(fields_to_self_hydrate=fields_to_self_hydrate, **kwargs)

class Initiative(SelfHydratingModel):
    initiative_uuid: UUID = uuid4()
    initiative_external_id: str
    name: str
    details_url: Optional[Url]
    title: str
    hero_image_url: Optional[Url] = generate_placeholder_image()
    content: MarkdownText
    roles: Optional[List[VolunteerRole]] = []
    events: Optional[List[VolunteerEvent]] = []
    highlightedItems: List[Union[VolunteerRole,VolunteerEvent]] = []

    def __init__(self, **kwargs):
        fields_to_self_hydrate = {
            'roles': VolunteerRole,
            'events': VolunteerEvent
        }

        super().__init__(fields_to_self_hydrate=fields_to_self_hydrate, **kwargs)

    @validator('roles')
    def guarantee_non_none_roles(cls, v):
        return v if v else []

    @validator('events')
    def guarantee_non_none_events(cls, v):
        return v if v else []

class PersonalDonationLinkRequest(BaseModel):
    email: EmailStr
    request_sent: datetime = NowUtc()
