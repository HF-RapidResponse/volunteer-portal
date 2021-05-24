from datetime import datetime
from pydantic import BaseModel
from typing import Optional
from uuid import UUID
from models.personal_identifier import IdentifierType
from schemas.account import AccountWithSettings

class IdentifierVerificationStart(BaseModel):
    identifier: str
    type: IdentifierType
    account_uuid: Optional[UUID]

class IdentifierVerificationFinishResponse(BaseModel):
    account: Optional[AccountWithSettings]
    msg: Optional[str]
