from models.base import Base
from datetime import datetime, timezone
from sqlalchemy import Column, String, DateTime, Boolean
from sqlalchemy.dialects.postgresql import UUID
from uuid import uuid4

class PersonalDonationLinkRequest(Base):
    __tablename__ = 'link_requests'

    request_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    email = Column('email', String(255))
    request_sent = Column('request_sent', DateTime)
    link_delivered = Column('link_delivered', Boolean)
