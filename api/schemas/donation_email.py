from fastapi import Form
from pydantic import BaseModel, EmailStr
import re

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
    email: EmailStr

    class Config:
        orm_mode = True
        arbitrary_types_allowed = True
