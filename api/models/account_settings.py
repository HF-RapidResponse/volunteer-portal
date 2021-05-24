from models.base import Base

from sqlalchemy import func, select, Column, String, Integer, Text, Boolean, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import ARRAY, JSON, UUID
from sqlalchemy.orm import backref, column_property, relationship, synonym
from sqlalchemy.ext.hybrid import hybrid_property
from pydantic import validator
from sqlalchemy.sql import func
from uuid import uuid4


class AccountSettings(Base):
    __tablename__ = 'account_settings'

    uuid = Column(UUID(as_uuid=True), primary_key=True,
                  default=uuid4, unique=True, nullable=False)
    account_uuid = Column(UUID(as_uuid=True), ForeignKey('accounts.uuid'), nullable=True)
    show_name = Column('show_name', Boolean, default=False, nullable=False)
    show_email = Column('show_email', Boolean, default=False, nullable=False)
    show_location = Column('show_location', Boolean,
                           default=True, nullable=False)
    organizers_can_see = Column(
        'organizers_can_see', Boolean, default=True, nullable=False)
    volunteers_can_see = Column(
        'volunteers_can_see', Boolean, default=True, nullable=False)
    # dictionary with initiative_name -> isSubscribed
    initiative_map = Column('initiative_map', JSON, default={}, nullable=False)
    password_reset_hash = Column('password_reset_hash', Text, nullable=True)
    password_reset_time = Column(
        'password_reset_time', DateTime, nullable=True)

    def __repr__(self):
        return "<AccountSettings(uuid='%s', show_name='%s', show_email='%s', show_location='%s', organizers_can_see='%s', volunteers_can_see='%s', initiative_map='%s', password_reset_hash='%s', password_reset_time='%s')>" % (
            self.uuid, self.show_name, self.show_email, self.show_location, self.organizers_can_see, self.volunteers_can_see, self.initiative_map, self.password_reset_hash, self.password_reset_time)
