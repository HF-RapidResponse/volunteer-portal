from datetime import datetime, timezone
from models.base import Base
import enum
from uuid import uuid4
from sqlalchemy import Column, Text, DateTime, Enum, ForeignKey, Boolean, UniqueConstraint
from sqlalchemy.orm import relationship, validates
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from uuid import uuid4
from email_validator import validate_email
import phonenumbers

class IdentifierType(enum.Enum):
    EMAIL = 0
    PHONE = 1
    SLACK_ID = 2
    GOOGLE_ID = 3

primary_join_query = f"""   or_(
                            and_(PersonalIdentifier.type=='EMAIL', PersonalIdentifier.uuid==foreign(Account.email_identifier_id)),
                            and_(PersonalIdentifier.type=='PHONE', PersonalIdentifier.uuid==foreign(Account.phone_number_identifier_id))
                            )"""

class PersonalIdentifier(Base):
    __tablename__ = 'personal_identifiers'

    uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    type = Column(Enum(IdentifierType), nullable=False)
    value = Column(Text, nullable=False)
    account_uuid = Column('account', UUID(as_uuid=True), ForeignKey('accounts.uuid'), nullable=True)
    account = relationship('Account', foreign_keys=[account_uuid], primaryjoin=primary_join_query, uselist=False)
    verified = Column(Boolean, default=False, nullable=False)

    # enforcing uniqueness on type + value will make app logic much simpler, we accept the problems if two people share the same email, phone, etc.
    __table_args__ = tuple(UniqueConstraint('type', 'value'))

    __mapper_args__ = {
        'polymorphic_on': type
    }

class EmailIdentifier(PersonalIdentifier):
    __mapper_args__ = {
        'polymorphic_identity':IdentifierType.EMAIL
    }

    @validates('value')
    def ensure_valid_email(self, _, value):
        return validate_email(value).email

class PhoneNumberIdentifier(PersonalIdentifier):
    __mapper_args__ = {
        'polymorphic_identity':IdentifierType.PHONE
    }

    @validates('value')
    def ensure_valid_email(self, _, value):
        value = phonenumbers.parse(value, None)
        assert phonenumbers.is_valid_number(value) is True
        return value

        
    #     return value

    # def __repr__(self):
    #     return "<Notification(notification_uuid='%s', channel='%s', status='%s', )>" % (
    #                             self.notification_uuid, self.channel, self.status)
