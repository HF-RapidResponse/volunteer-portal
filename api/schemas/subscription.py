from pydantic import BaseModel, EmailStr
from uuid import UUID
from typing import Optional

from schemas.personal_identifier_verification import IdentifierVerificationStart

class SubscribeRequest(BaseModel):
  entity_type: str
  entity_uuid: UUID

  identifier: Optional[IdentifierVerificationStart]

  class Config:
        orm_mode = True

class UnsubscribeRequest(BaseModel):
  identifier: Optional[IdentifierVerificationStart]

  class Config:
        orm_mode = True
