from pydantic import BaseModel, EmailStr

from typing import List, Dict, Text, Optional
from uuid import UUID

class GroupBaseSchema(BaseModel):
    group_name: str
    location_description: str
    zip_code: Optional[str]

    class Config:
        orm_mode = True

class GroupFullSchema(GroupBaseSchema):
  description: Optional[Text]
  social_media_links: Dict
