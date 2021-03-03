from models.base import Base
from models.personal_identifier import IdentifierType
from sqlalchemy import func, select, Column, String, Integer, Text, Boolean, ForeignKey
from sqlalchemy.dialects.postgresql import ARRAY, JSON, UUID
from sqlalchemy.orm import backref, column_property, relationship, synonym, validates
from sqlalchemy.ext.hybrid import hybrid_property
from pydantic import validator
from sqlalchemy.sql import func
from uuid import uuid4


class Account(Base):
    __tablename__ = 'accounts'

    uuid = Column(UUID(as_uuid=True), primary_key=True,
                  default=uuid4, unique=True, nullable=False)
    username = Column('username', String(255), nullable=True)
    first_name = Column('first_name', String(255), nullable=True)
    last_name = Column('last_name', String(255), nullable=True)
    email_identifier_id = Column(UUID(as_uuid=True), ForeignKey('personal_identifiers.uuid'))
    email_identifier = relationship("EmailIdentifier", foreign_keys=[email_identifier_id], back_populates='account', uselist=False)
    phone_number_identifier_id = Column(UUID(as_uuid=True), ForeignKey('personal_identifiers.uuid'))
    phone_number_identifier = relationship("PhoneNumberIdentifier", foreign_keys=[phone_number_identifier_id], back_populates='account', uselist=False)
    
    @hybrid_property
    def email(self):
        return self.email_identifier.value
    
    @hybrid_property
    def phone_number(self):
        return self.phone_number_identifier.value

    def __repr__(self):
        return "<Account(uuid='%s', email='%s', username='%s', first_name='%s', last_name='%s', email_identifier_id='%s', phone_number_identifier_id='%s')>" % (
            self.uuid, self.email, self.username, self.first_name, self.last_name, self.email_identifier_id, self.phone_number_identifier_id)
