from datetime import datetime
from pydantic import BaseModel
from typing import List, Optional, Union
from schemas.volunteer_event import VolunteerEventSchema
from schemas.volunteer_role import VolunteerRoleSchema
from uuid import UUID

Url = str
MarkdownText = str

class InitiativeSchema(BaseModel):
    uuid: UUID
    external_id: str
    initiative_name: str
    order: int
    details_url: Optional[Url]
    hero_image_url: Optional[Url]
    content: MarkdownText
    role_ids: List
    event_ids: List

    class Config:
        orm_mode = True


# Initiatives with roles and events included
class NestedInitiativeSchema(InitiativeSchema):
    roles: Optional[List[VolunteerRoleSchema]] = []
    events: Optional[List[VolunteerEventSchema]] = []

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True
