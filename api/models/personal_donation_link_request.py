<<<<<<< HEAD
from pydantic import BaseModel, EmailStr
from datetime import datetime, timezone
NowUtc = lambda: datetime.now(tz=timezone.utc)
from data_sources import DataSink
from settings import connections, donations

import logging
logging.basicConfig(level=logging.INFO)

class PersonalDonationLinkRequest(BaseModel):
    email: EmailStr
    request_sent: datetime = NowUtc()

    # def insert(link_request):
        # if db().insert(link_request)
        #     logging.debug(f'Inserting {link_request} to db')
        # else
        #     logging.error('Cannot insert to donation link DB, connecting failed.')
        #
        # return link_request

def db():
    d = DataSink(data_base_type=donations['engine'], address=connections['donations'], table='link_requests')
    d: Optional[DataSink] = None
    return d
=======
from models.base import Base
from datetime import datetime, timezone
from sqlalchemy import Column, String, DateTime, Boolean # type: ignore
from sqlalchemy.dialects.postgresql import UUID # type: ignore
from uuid import uuid4

class PersonalDonationLinkRequest(Base):
    __tablename__ = 'link_requests'

    request_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    email = Column('email', String(255))
    request_sent = Column('request_sent', DateTime)
    link_delivered = Column('link_delivered', Boolean)
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
