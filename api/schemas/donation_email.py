from datetime import datetime
from fastapi import Form
from pydantic import BaseModel, validator
import re
from uuid import UUID

email_regex = '^[a-z0-9]+[\._]?[a-z0-9]+[@]\w+[.]\w{2,3}$'

def form_body(cls):
    cls.__signature__ = cls.__signature__.replace(
        parameters=[
            arg.replace(default=Form(...))
            for arg in cls.__signature__.parameters.values()
        ]
    )
    return cls

@form_body
class DonationEmailSchema(BaseModel):
    email: str

    @validator('email')
    def validate_email(cls, em):
        if len(em) > 7:
            if re.search(email_regex, em) != None:
                return em
            else:
                raise ValueError('is not a valid email')

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True
