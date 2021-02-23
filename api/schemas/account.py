from pydantic import BaseModel, EmailStr
from typing import List, Dict, Text, Optional
from uuid import UUID


class AccountRequestSchema(BaseModel):
    email: EmailStr
    username: Optional[str]
    first_name: str
    last_name: str
    profile_pic: Optional[Text]
    city: Optional[str]
    state: Optional[str]
    roles: Optional[List]
    initiative_map: Optional[Dict]
    organizers_can_see: bool
    volunteers_can_see: bool

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True


class AccountResponseSchema(AccountRequestSchema):
    uuid: UUID
