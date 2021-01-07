from datetime import datetime
from pydantic import BaseModel
from uuid import UUID

Url = str

class DonationEmailSchema(BaseModel):
    donation_uuid: UUID
    email: str
    request_sent: datetime

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True
