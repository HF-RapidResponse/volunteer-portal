from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime, timezone
import uuid
from uuid import uuid4

NowUtc = lambda: datetime.now(tz=timezone.utc)

class PersonalDonationLinkRequestSchema(BaseModel):
    request_uuid: uuid.UUID = uuid4()
    email: EmailStr
    request_sent: datetime = NowUtc()
    link_delivered: bool = False
