from pydantic import BaseModel, EmailStr
from typing import List, Dict, Text, Optional
from uuid import UUID


class AccountSettingsSchema(BaseModel):
    uuid: UUID
    show_name: bool
    show_email: bool
    show_location: bool
    organizers_can_see: bool
    volunteers_can_see: bool
    initiative_map: Dict

    class Config:
        orm_mode = True
