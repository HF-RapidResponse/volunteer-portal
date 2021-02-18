from pydantic import BaseModel, EmailStr
from typing import List, Dict
from uuid import UUID


class AccountRequestSchema(BaseModel):
    email: EmailStr
    username: str
    first_name: str
    last_name: str
    city: str
    state: str
    roles: List
    initiative_map: Dict

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True


class AccountResponseSchema(AccountRequestSchema):
    uuid: UUID
