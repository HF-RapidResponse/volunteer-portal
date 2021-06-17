from datetime import datetime, timezone
from models.base import Base
import enum
from uuid import uuid4
from pydantic import EmailStr
from sqlalchemy import Column, Text, DateTime, Enum, ForeignKey, Boolean, UniqueConstraint
from sqlalchemy.orm import relationship, validates
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.ext.indexable import index_property
from sqlalchemy.sql import func
from sqlalchemy import Index
from uuid import uuid4
import phonenumbers
from models.subscription import Subscription

class IdentifierType(enum.Enum):
    EMAIL = 'email'
    PHONE = 'phone_number'
    SLACK_ID = 'slack_member_id'
    GOOGLE_ID = 'google_id'
    GITHUB_ID = 'github_id'

class PersonalIdentifier(Base):
    __tablename__ = 'personal_identifiers'

    uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    type = Column(Enum(IdentifierType), nullable=False)
    value = Column(Text, nullable=False)
    account_uuid = Column(UUID(as_uuid=True), ForeignKey('accounts.uuid'), nullable=True)
    account = relationship('Account', foreign_keys=[account_uuid], back_populates='personal_identifiers')
    verified = Column(Boolean, default=False, nullable=False)
    verification_token = relationship('VerificationToken', back_populates='personal_identifier', uselist=False, cascade='delete')

    subscriptions = relationship('Subscription', foreign_keys=[Subscription.identifier_uuid], cascade='delete')
    # enforcing uniqueness on type + value will make app logic much simpler, we accept the problems if two people share the same email, phone, etc.
    __table_args__ = (UniqueConstraint('type', 'value'),
                      Index('ix_account_uuid', 'account_uuid', postgresql_using='hash'),
                      Index('ix_value', 'value', postgresql_using='hash'))

    __mapper_args__ = {
        'polymorphic_on': type
    }

    @validates('value')
    def ensure_valid_value(self, _, value):
        if self.type is IdentifierType.EMAIL:
            EmailStr.validate(value)
            return value
        elif self.type is IdentifierType.PHONE:
            phone_number_obj = phonenumbers.parse(value, None)
            assert phonenumbers.is_valid_number(phone_number_obj)
            return phonenumbers.format_number(phone_number_obj, phonenumbers.PhoneNumberFormat.E164)
        else:
            return value
    
    def __repr__(self):
        return "<PersonalIdentifier(uuid='%s', type='%s', value='%s', verified='%s', account_uuid='%s')>" % (
                                self.uuid, self.type, self.value, self.verified, self.account_uuid)

class EmailIdentifier(PersonalIdentifier):
    pass

class StandardEmailIdentifier(EmailIdentifier):
    __mapper_args__ = {
        'polymorphic_identity':IdentifierType.EMAIL
    }

class GoogleEmailIdentifier(EmailIdentifier):
    __mapper_args__ = {
        'polymorphic_identity':IdentifierType.GOOGLE_ID
    }

    # so apparently this isn't a feature yet: https://github.com/sqlalchemy/sqlalchemy/issues/2943
    # @validates('value')
    # def ensure_valid_email(self, _, value):
    #     raise ValueError
    #     return validate_email(value).email

# TODO this really shouldn't be an email identifier, but the frontend still expects and email for
# every account.
class GithubIdentifier(EmailIdentifier):
    __mapper_args__ = {
        'polymorphic_identity':IdentifierType.GITHUB_ID
    }

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
