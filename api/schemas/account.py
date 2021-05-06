from pydantic import BaseModel, EmailStr
from typing import List, Dict, Text, Optional
from uuid import UUID

class AccountPublicBaseSchema(BaseModel):
    username: Optional[str]
    first_name: Optional[str]
    profile_pic: Optional[Text]
    city: Optional[str]
    state: Optional[str]

    class Config:
        orm_mode = True

class AccountBaseSchema(BaseModel):
    email: Optional[EmailStr]
    username: Optional[str]
    first_name: Optional[str]
    last_name: Optional[str]
    oauth: Optional[str]
    profile_pic: Optional[Text]
    city: Optional[str]
    state: Optional[str]
    zip_code: Optional[str]
    roles: Optional[List]
    is_verified: Optional[bool]

    class Config:
        orm_mode = True


class AccountCreateRequestSchema(AccountBaseSchema):
    password: Text


class AccountResponseSchema(AccountBaseSchema):
    uuid: UUID


class AccountBasicLoginSchema(BaseModel):
    email: EmailStr
    password: Text


class AccountPasswordSchema(BaseModel):
    old_password: Text
    uuid: UUID


class AccountNewPasswordSchema(BaseModel):
    password: Text


class AccountNotificationSchema(BaseModel):
    username: Optional[str]
    email: Optional[str]
    notification_type: str
