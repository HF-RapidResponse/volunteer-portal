from datetime import datetime
from models import Person, Priority, RoleType
from pydantic import BaseModel
from typing import Optional
from uuid import UUID

Url = str
MarkdownText = str


class VolunteerEventSchema(BaseModel):
    uuid: UUID
    external_id: str
    event_name: str
    signup_url: str
    hero_image_url: Optional[Url]
    details_url: Optional[Url]
    start_datetime: datetime
    end_datetime: Optional[datetime]
    description: Optional[MarkdownText]

    class Config:
        orm_mode = True
