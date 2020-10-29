from pydantic import BaseModel
from typing import Optional, Union, List
from enum import Enum
from uuid import UUID, uuid4
from datetime import datetime

Url = str
MarkdownText = str

class Person(BaseModel):
    name: str

class Priority(Enum):
    TOP_PRIORITY = 'top_priority'
    HIGH = 'high'
    MEDIUM = 'medium'
    LOW = 'low'
    VERY_LOW = 'Could be nice'
    NONE = None

class VolunteerRole(BaseModel):
    role_uuid: UUID = uuid4()
    role_external_id: str
    details_url: Optional[Url]
    hero_image_url: Optional[Url]
    priority: Optional[Priority]
    signup_url: Url
    point_of_contact: Optional[Person]
    num_openings: Optional[int]
    min_time_commitment: Optional[int]
    max_time_commitment: Optional[int]
    overview: Optional[MarkdownText]
    benefits: Optional[MarkdownText]
    responsibilites: Optional[MarkdownText]
    qualifications: Optional[MarkdownText]

class VolunteerEvent(BaseModel):
    event_uuid: UUID = uuid4()
    event_external_id: str
    details_url: Optional[Url]
    start_datetime: datetime
    end_datetime: Optional[datetime]
    description: Optional[MarkdownText]
    point_of_contact: Optional[Person]
    sign_up_link: Optional[Url]

class Initiative(BaseModel):
    initiative_uuid: UUID = uuid4()
    initiative_external_id: str
    details_url: Optional[Url]
    title: str
    hero_image_url: Url
    content: MarkdownText
    highlightedItems: Optional[List[Union[VolunteerRole,VolunteerEvent]]]