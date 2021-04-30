from pydantic import BaseModel, EmailStr
from typing import List, Dict, Text, Optional
from datetime import datetime
from uuid import UUID


class AccountSettingsSchema(BaseModel):
    uuid: UUID
    show_name: bool
    show_email: bool
    show_location: bool
    organizers_can_see: bool
    volunteers_can_see: bool
    initiative_map: Dict
    password_reset_hash: Optional[Text]
    password_reset_time: Optional[datetime]
    verify_account_hash: Optional[Text]
    cancel_registration_hash: Optional[Text]

    class Config:
        orm_mode = True
