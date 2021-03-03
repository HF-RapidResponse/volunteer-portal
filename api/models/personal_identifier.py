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
    EMAIL = 'email'
    PHONE = 'phone_number'
    SLACK_ID = 'slack_member_id'
    GOOGLE_ID = 'google_id'

class PersonalIdentifier(Base):
    __tablename__ = 'personal_identifiers'

    uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    type = Column(Enum(IdentifierType), nullable=False)
    value = Column(Text, nullable=False)
    account_uuid = Column(UUID(as_uuid=True), ForeignKey('accounts.uuid'), nullable=True)
    account = relationship('Account', foreign_keys=[account_uuid], back_populates='personal_identifiers')
    verified = Column(Boolean, default=False, nullable=False)
    verification_token = relationship('VerificationToken', back_populates='personal_identifier', uselist=False)

    # enforcing uniqueness on type + value will make app logic much simpler, we accept the problems if two people share the same email, phone, etc.
    __table_args__ = tuple(UniqueConstraint('type', 'value'))

    __mapper_args__ = {
        'polymorphic_on': type
    }

    @validates('value')
    def ensure_valid_value(self, _, value):
        if self.type is IdentifierType.EMAIL:
            return validate_email(value).email
        elif self.type is IdentifierType.PHONE:
            phone_number_obj = phonenumbers.parse(value, None)
            assert phonenumbers.is_valid_number(phone_number_obj)
            return phonenumbers.format_number(phone_number_obj, phonenumbers.PhoneNumberFormat.E164)
    
    def __repr__(self):
        return "<PersonalIdentifier(uuid='%s', type='%s', value='%s', verified='%s', account_uuid='%s')>" % (
                                self.uuid, self.type, self.value, self.verified, self.account_uuid)

class EmailIdentifier(PersonalIdentifier):
    __mapper_args__ = {
        'polymorphic_identity':IdentifierType.EMAIL
    }

    # so apparently this isn't a feature yet: https://github.com/sqlalchemy/sqlalchemy/issues/2943
    # @validates('value')
    # def ensure_valid_email(self, _, value):
    #     raise ValueError
    #     return validate_email(value).email

class PhoneNumberIdentifier(PersonalIdentifier):
    __mapper_args__ = {
        'polymorphic_identity':IdentifierType.PHONE
    }

    # @validates('value')
    # def ensure_valid_email(self, _, value):
    #     phone_number_obj = phonenumbers.parse(value, None)
    #     assert phonenumbers.is_valid_number(phone_number_obj)
    #     return phonenumbers.format_number(phone_number_obj, phonenumbers.PhoneNumberFormat.E164)

class SlackIdentifier(PersonalIdentifier):
    __mapper_args__ = {
        'polymorphic_identity':IdentifierType.SLACK_ID
    }

    slack_workspace_id = Column(Text)

    __table_args__ = tuple(UniqueConstraint('type', 'value', 'slack_workspace_id'))
