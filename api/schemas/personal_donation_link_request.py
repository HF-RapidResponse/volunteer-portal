from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime, timezone
import uuid

NowUtc = lambda: datetime.now(tz=timezone.utc)

class PersonalDonationLinkRequestSchema(BaseModel):
    request_uuid: uuid.UUID = None
    email: EmailStr
    request_sent: datetime = NowUtc()
    link_delivered: bool = False
