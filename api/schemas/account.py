from pydantic import BaseModel, EmailStr
from typing import List, Dict, Text, Optional
from uuid import UUID


class AccountRequestSchema(BaseModel):
    email: EmailStr
    username: Optional[str]
    first_name: str
    last_name: str
    password: Optional[Text]
    oauth: Optional[str]
    profile_pic: Optional[Text]
    city: Optional[str]
    state: Optional[str]
    roles: Optional[List]

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True


class AccountResponseSchema(AccountRequestSchema):
    uuid: UUID


class AccountBasicLoginSchema(BaseModel):
    email: EmailStr
    password: Text


class AccountPasswordSchema(BaseModel):
    old_password: Text
    uuid: UUID


class PartialAccountSchema(BaseModel):
    first_name: Optional[str]
    last_name: Optional[str]
    password: Optional[Text]
    oauth: Optional[str]
    profile_pic: Optional[Text]
    city: Optional[str]
    state: Optional[str]
    roles: Optional[List]

    # class Config:
    #     orm_mode = True
