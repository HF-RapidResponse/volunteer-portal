from pydantic import BaseModel, EmailStr
from typing import List, Dict, Text, Optional
from uuid import UUID


class AccountRequestSchema(BaseModel):
    email: EmailStr
    username: str
    first_name: str
    last_name: str
    profile_pic: Optional[Text]
    city: Optional[str]
    state: Optional[str]
    roles: Optional[List]
    initiative_map: Optional[Dict]

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True


class AccountResponseSchema(AccountRequestSchema):
    uuid: UUID
