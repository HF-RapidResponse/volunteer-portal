from datetime import datetime
from pydantic import BaseModel
from typing import List, Optional, Union
from schemas.volunteer_event import VolunteerEventSchema
from schemas.volunteer_role import VolunteerRoleSchema
from uuid import UUID

Url = str
MarkdownText = str

class InitiativeSchema(BaseModel):
    initiative_uuid: UUID
    initiative_external_id: str
    name: str
    details_url: Optional[Url]
    title: str
    hero_image_url: Optional[Url]
    content: MarkdownText
    role_ids: List

    class Config:
        orm_mode = True


# Initiatives with roles and events included
class NestedInitiativeSchema(InitiativeSchema):
    roles: Optional[List[VolunteerRoleSchema]] = []
    events: Optional[List[VolunteerEventSchema]] = []
    highlightedItems: List[Union[VolunteerRoleSchema,VolunteerEventSchema]] = []

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True
