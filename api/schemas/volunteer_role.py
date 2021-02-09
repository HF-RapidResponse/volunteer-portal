from models import Person, Priority, RoleType
from pydantic import BaseModel
from typing import Optional
from uuid import UUID

Url = str
MarkdownText = str

class VolunteerRoleSchema(BaseModel):
    uuid: UUID
    external_id: str
    role_name: str
    hero_image_url: Url
    signup_url: Optional[Url]
    details_url: Optional[Url]
    priority: Priority
    # TODO: team & team lead not implemented. Needs HFRR teams DB sync.
    num_openings: Optional[int]
    min_time_commitment: Optional[int]
    max_time_commitment: Optional[int]
    overview: Optional[MarkdownText]
    benefits: Optional[MarkdownText]
    responsibilities: Optional[MarkdownText]
    qualifications: Optional[MarkdownText]
    role_type: RoleType

    class Config:
        orm_mode = True
