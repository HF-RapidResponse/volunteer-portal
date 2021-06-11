from models.base import Base

from models.personal_identifier import IdentifierType, EmailIdentifier, PhoneNumberIdentifier, PersonalIdentifier
from models.account_settings import AccountSettings
from sqlalchemy import func, select, Column, String, Integer, Text, Boolean, ForeignKey, UniqueConstraint, Index
from sqlalchemy.dialects.postgresql import ARRAY, JSON, UUID
from sqlalchemy.orm import backref, column_property, relationship, synonym, validates
from sqlalchemy.ext.hybrid import hybrid_property
from pydantic import validator
from sqlalchemy.sql import func
from uuid import uuid4


class Account(Base):
    """
    Attributes
    ----------
    uuid : uuid
        the account's unique identifier
    username : str
        the user-defined public username for this account
    first_name : str
        the user's first name
    last_name : str
        the user's last name
    personal_identifiers : list of PersonalIdentifier
        the list of all personal identifiers linked to this account
    primary_email_identifier : EmailIdentifier
        the EmailIdentifier object for the user's preferred email
    primary_email : str
        the user's preferred email address
    primary_phone_number_identifier : PhoneNumberIdentifier
        the PhoneNumberIdentifier object for the user's preferred phone number
    primary_phone_number: str
        the user's preferred phone number
    """

    __tablename__ = 'accounts'

    uuid = Column(UUID(as_uuid=True), primary_key=True,
                  default=uuid4, unique=True, nullable=False)
    username = Column('username', String(255), nullable=True, unique=True)
    first_name = Column('first_name', String(255), nullable=True)
    last_name = Column('last_name', String(255), nullable=True)
    # passwords are encrypted using passlib with pbkdf2_sha256 hashing (see security.py)
    password = Column('password', Text, nullable=True)
    profile_pic = Column('profile_pic', Text, nullable=True)
    city = Column('city', String(32), nullable=True)
    state = Column('state', String(32), nullable=True)
    roles = Column('roles', ARRAY(String), default=[], nullable=False)
    zip_code = Column('zip_code', String(32), nullable=True)
    settings = relationship('AccountSettings', foreign_keys=[AccountSettings.account_uuid], uselist=False, cascade='delete')
    personal_identifiers = relationship('PersonalIdentifier', back_populates='account', foreign_keys=[PersonalIdentifier.account_uuid], cascade='delete')

    _primary_email_identifier_uuid = Column(UUID(as_uuid=True), ForeignKey('personal_identifiers.uuid'))
    _primary_email_identifier = relationship('EmailIdentifier', foreign_keys=[_primary_email_identifier_uuid], uselist=False, post_update=True)
    _primary_phone_number_identifier_uuid = Column(UUID(as_uuid=True), ForeignKey('personal_identifiers.uuid'))
    _primary_phone_number_identifier = relationship('PhoneNumberIdentifier', foreign_keys=[_primary_phone_number_identifier_uuid], uselist=False, post_update=True)

    @hybrid_property
    def primary_identifier(self):
        if self._primary_email_identifier:
            return self._primary_email_identifier
        assert len(self.personal_identifiers) > 0, (
            'unexpected account state with no identifiers')
        return self.personal_identifiers[0]

    @hybrid_property
    def primary_identifier_type(self):
        return self.primary_identifier.type.value

    @hybrid_property
    def primary_email_identifier(self):
        return self._primary_email_identifier

    @primary_email_identifier.setter
    def primary_email_identifier(self, email_identifier):
        if not email_identifier:
            return
        assert isinstance(email_identifier, EmailIdentifier)
        self._primary_email_identifier = email_identifier
        email_identifier.account = self

    @hybrid_property
    def primary_phone_number_identifier(self):
        return self._primary_phone_number_identifier

    @primary_phone_number_identifier.setter
    def primary_phone_number_identifier(self, phone_number_identifier):
        assert type(phone_number_identifier) is PhoneNumberIdentifier
        self._primary_phone_number_identifier = phone_number_identifier
        phone_number_identifier.account = self

    @hybrid_property
    def email(self):
        return self._primary_email_identifier.value if self._primary_email_identifier else None

    @hybrid_property
    def primary_phone_number(self):
        return self._primary_phone_number_identifier.value if self._primary_phone_number_identifier else None

    def __repr__(self):
        return "<Account(uuid='%s', email='%s', username='%s', first_name='%s', primary_email_identifier_uuid='%s', primary_phone_number_identifier_uuid='%s')>" % (
            self.uuid, self.email, self.username, self.first_name, self._primary_email_identifier_uuid, self._primary_phone_number_identifier_uuid)
