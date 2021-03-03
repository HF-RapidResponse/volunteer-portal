from datetime import datetime
from pydantic import BaseModel
from typing import Optional
from uuid import UUID



class IdentifierValidationStart(BaseModel):
    identifier: str
    account_UUID: Optional[UUID]

class IdentifierValidationConfirm(BaseModel):
    identifier_validation_UUID: UUID
