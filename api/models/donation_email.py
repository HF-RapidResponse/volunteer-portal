from datetime import datetime, timezone
from models.base import Base
from uuid import uuid4
from sqlalchemy import Column, Text, DateTime
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from uuid import uuid4

NowUtc = lambda: datetime.now(tz=timezone.utc)

class DonationEmail(Base):
    __tablename__ = 'donation_emails'

    donation_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    email = Column('email', Text)
    request_sent = Column('request_sent_date', DateTime, default=func.now())

    def __repr__(self):
        return "<DonationEmail(donation_uuid='%s', email='%s', request_sent='%s')>" % (
                                self.donation_uuid, self.email, self.request_sent)
