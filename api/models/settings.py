from models.base import Base

from sqlalchemy import func, select, Column, String, Integer, Text, Boolean
from sqlalchemy.dialects.postgresql import ARRAY, JSON, UUID
from sqlalchemy.orm import backref, column_property, relationship, synonym
from sqlalchemy.ext.hybrid import hybrid_property
from pydantic import validator
from sqlalchemy.sql import func
from uuid import uuid4


class Settings(Base):
    __tablename__ = 'Settings'

    uuid = Column(UUID(as_uuid=True), primary_key=True,
                  default=uuid4, unique=True, nullable=False)
    email = Column('email', Text, unique=True, nullable=False)
    username = Column('username', String(255), nullable=True)
    first_name = Column('first_name', String(255), nullable=True)
    last_name = Column('last_name', String(255), nullable=True)
    password = Column('password', Text, nullable=True)
    oauth = Column('oauth', String(32), nullable=True)
    profile_pic = Column('profile_pic', Text, nullable=True)
    city = Column('city', String(32), nullable=True)
    state = Column('state', String(32), nullable=True)
    roles = Column('roles', ARRAY(String), default=[], nullable=False)
    initiative_map = Column('initiative_map', JSON, default={}, nullable=False)
    organizers_can_see = Column(
        'organizers_can_see', Boolean, default=True, nullable=False)
    volunteers_can_see = Column(
        'volunteers_can_see', Boolean, default=True, nullable=False)

    def __repr__(self):
        return "<Account(uuid='%s', email='%s', username='%s', first_name='%s', last_name='%s', password='%s', oauth='%s', profile_pic='%s', city='%s', state='%s', roles='%s', initiative_map='%s', organizers_can_see='%s', volunteers_can_see='%s')>" % (
            self.uuid, self.email, self.username, self.first_name, self.last_name, self.password, self.oauth, self.profile_pic, self.city, self.state, self.roles, self.initiative_map, self.organizers_can_see, self.volunteers_can_see)
