from models.base import Base

from sqlalchemy import func, select, Column, String, Integer, Text
from sqlalchemy.dialects.postgresql import ARRAY, JSON, UUID
from sqlalchemy.orm import backref, column_property, relationship, synonym
from sqlalchemy.ext.hybrid import hybrid_property
from pydantic import validator
from sqlalchemy.sql import func
from uuid import uuid4


class Account(Base):
    __tablename__ = 'accounts'

    uuid = Column(UUID(as_uuid=True), primary_key=True,
                  default=uuid4, unique=True, nullable=False)
    acct_email: Column('acct_email', Text)
    username: Column('username', String(255), nullable=True)
    first_name: Column('first_name', String(255), nullable=True)
    last_name: Column('last_name', String(255), nullable=True)
    city: Column('city', String(32), nullable=True)
    state: Column('state', String(16), nullable=True)
    roles: Column('roles', ARRAY(String), default=[], nullable=False)
    initiative_map: Column('initiative_map', JSON, default={}, nullable=False)

    def __repr__(self):
        return "<Account(uuid='%s', acct_email='%s', username='%s', first_name='%s', last_name='%s', city='%s', state='%s', roles='%s', initiative_map='%s')>" % (
            self.uuid, self.acct_email, self.username, self.first_name, self.last_name, self.city, self.state, self.roles, self.initiative_map)
