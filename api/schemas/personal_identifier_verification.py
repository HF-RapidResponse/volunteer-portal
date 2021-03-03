from datetime import datetime
from pydantic import BaseModel
from typing import Optional
from uuid import UUID
from models.personal_identifier import IdentifierType

class IdentifierVerificationStart(BaseModel):
    identifier: str
    type: IdentifierType

class IdentifierVerificationFinish(BaseModel):
    verification_token_uuid: UUID
    otp: str
