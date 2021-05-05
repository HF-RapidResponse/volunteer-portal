from pydantic import BaseModel, EmailStr

from models import Relationship

from typing import List, Dict, Text, Optional
from uuid import UUID

class GroupBaseSchema(BaseModel):
    uuid: UUID
    group_name: str
    location_description: str
    zip_code: Optional[str]

    class Config:
        orm_mode = True

class GroupFullSchema(GroupBaseSchema):
  description: Optional[Text]
  social_media_links: Dict

class GroupRelation(GroupBaseSchema):
    relationship: Relationship

class GroupStats(BaseModel):
    group: GroupBaseSchema

    stats: Dict

    class Config:
        orm_mode = True
