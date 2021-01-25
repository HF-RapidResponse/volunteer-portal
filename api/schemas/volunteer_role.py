from models import Person, Priority, RoleType
from pydantic import BaseModel
from typing import Optional
from uuid import UUID

Url = str
MarkdownText = str

class VolunteerRoleSchema(BaseModel):
    role_uuid: UUID
    role_external_id: str
    name: str
    hero_image_url: Url
    signup_url: Optional[Url]
    details_url: Optional[Url]
    priority: Priority
    role_type: RoleType
    point_of_contact: Optional[Person]
    num_openings: Optional[int]
    min_time_commitment: Optional[int]
    max_time_commitment: Optional[int]
    overview: Optional[MarkdownText]
    benefits: Optional[MarkdownText]
    responsibilites: Optional[MarkdownText]
    qualifications: Optional[MarkdownText]

    class Config:
        orm_mode = True
