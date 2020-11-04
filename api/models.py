from pydantic import BaseModel
from typing import Optional, Union, List
from enum import Enum
from uuid import UUID, uuid4
from datetime import datetime

Url = str
MarkdownText = str

def generate_placeholder_image() -> Url:
    return 'https://actblue-indigo-uploads.s3.amazonaws.com/uploads/list-editor/brandings/65454/header/image_url/f7edc334-2217-43b9-b707-5b7eaed92c1b-logo_stacked.svg'

class Person(BaseModel):
    name: str

class Priority(Enum):
    TOP_PRIORITY = 'top_priority'
    HIGH = 'high'
    MEDIUM = 'medium'
    LOW = 'low'
    NONE = None

class VolunteerRole(BaseModel):
    role_uuid: UUID = uuid4()
    role_external_id: str
    name: str
    hero_image_url: Url = generate_placeholder_image()
    signup_url: Url
    details_url: Optional[Url]
    priority: Priority = Priority.LOW
    point_of_contact: Optional[Person]
    num_openings: int = 1
    min_time_commitment: Optional[int]
    max_time_commitment: Optional[int]
    overview: Optional[MarkdownText]
    benefits: Optional[MarkdownText]
    responsibilites: Optional[MarkdownText]
    qualifications: Optional[MarkdownText]

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

class Initiative(BaseModel):
    initiative_uuid: UUID = uuid4()
    initiative_external_id: str
    name: str
    details_url: Optional[Url]
    title: str
    hero_image_url: Url = generate_placeholder_image()
    content: MarkdownText
    roles: List[VolunteerRole] = []
    events: List[VolunteerEvent] = []
    highlightedItems: List[Union[VolunteerRole,VolunteerEvent]] = []
