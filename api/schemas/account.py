from pydantic import BaseModel, EmailStr
from typing import List, Dict, Text, Optional
from uuid import UUID
from models.personal_identifier import IdentifierType
from schemas.account_settings import AccountSettingsSchema

class AccountBaseSchema(BaseModel):
    username: Optional[str]
    first_name: Optional[str]
    last_name: Optional[str]
    profile_pic: Optional[Text]
    city: Optional[str]
    state: Optional[str]
    zip_code: Optional[str]
    roles: Optional[List]
    class Config:
        orm_mode = True

class IdentifierVerificationCreate(BaseModel):
    identifier: str
    type: IdentifierType

class AccountCreateRequestSchema(BaseModel):
    account: AccountBaseSchema
    identifier: IdentifierVerificationCreate
    password: Text
    class Config:
        orm_mode = True

class AccountResponseSchema(AccountBaseSchema):
    uuid: UUID
    email: Optional[EmailStr]


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

class AccountWithSettings(AccountResponseSchema):
    settings: Optional[AccountSettingsSchema]
