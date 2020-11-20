from pydantic import BaseModel, EmailStr, validator
from typing import Optional, Union, List, Type, Any
from enum import Enum
from uuid import UUID, uuid4
from datetime import datetime, timezone

from data_sources import get_dataset_for_model

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
    
class VolunteerRole(BaseModel):
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

    @validator('point_of_contact', pre=True)
    def fetch_point_of_contact(cls, v):
        return fetch_model_for_field(cls, v, Person)

class VolunteerEvent(BaseModel):
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

    @validator('point_of_contact', pre=True)
    def fetch_point_of_contact(cls, v):
        return fetch_model_for_field(cls, v, Person)

class Initiative(BaseModel):
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

    @validator('roles', pre=True)
    def fetch_roles(cls, v):
        return fetch_model_for_field(cls, v, VolunteerRole)

    @validator('roles')
    def guarantee_non_none_roles(cls, v):
        return v if v else []
    
    @validator('events', pre=True)
    def fetch_events(cls, v):
        return fetch_model_for_field(cls, v, VolunteerEvent)

    @validator('events')
    def guarantee_non_none_events(cls, v):
        return v if v else []

class PersonalDonationLinkRequest(BaseModel):
    email: EmailStr
    request_sent: datetime = NowUtc()

def fetch_model_for_field(cls: Type, v: Any, field_model: Type) -> Any:
    def get_model_for_primary_key(v: Any, field_model: Type) -> Any:
        dataset = get_dataset_for_model(field_model)
        if dataset:
            return dataset.get_linked_model_object_for_primary_key(v)
        else:
            return v
    
    if type(v) is str:
        # v is a primitive string, attempt to fetch pydantic object by ID
        return get_model_for_primary_key(v, field_model)
    elif type(v) is list:
        if v and type(v[-1]) is str:
            # v is a list of primitive strings, attempt to fetch list of pydantic objects
            # this filters out nested objects that fail validation
            return [instance for key in v if (instance := get_model_for_primary_key(key, field_model))]
        else:
            return v
    else:
        # v is either a pydantic object, a valid dict of keys for that model, or an invalid input
        # Let pydantic field validation handle organically
        return v
