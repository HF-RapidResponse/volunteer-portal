from datetime import datetime
from models import Person, Priority, RoleType
from pydantic import BaseModel
from typing import Optional
from uuid import UUID

Url = str
MarkdownText = str

class VolunteerEventSchema(BaseModel):
    event_uuid: UUID
    event_external_id: str
    name: str
    signup_url: str
    hero_image_url: Url
    details_url: Optional[Url]
    start_datetime: datetime
    end_datetime: Optional[datetime]
    description: Optional[MarkdownText]
    point_of_contact: Optional[Person]

    class Config:
        orm_mode = True
