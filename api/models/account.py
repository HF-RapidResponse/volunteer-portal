from models.base import Base

from sqlalchemy import func, select, Column, String, Integer, Text, Boolean, UniqueConstraint
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
    email = Column('email', Text, unique=True, nullable=False, index=True)
    username = Column('username', String(255), unique=True,
                      nullable=False, index=True)
    first_name = Column('first_name', String(255), nullable=True)
    last_name = Column('last_name', String(255), nullable=True)
    # passwords are encrypted using passlib with pbkdf2_sha256 hashing (see security.py)
    password = Column('password', Text, nullable=True)
    oauth = Column('oauth', String(32), nullable=True)
    profile_pic = Column('profile_pic', Text, nullable=True)
    city = Column('city', String(32), nullable=True)
    state = Column('state', String(32), nullable=True)
    roles = Column('roles', ARRAY(String), default=[], nullable=False)
    zip_code = Column('zip_code', String(32), nullable=True)

    def __repr__(self):
        return "<Account(uuid='%s', email='%s', username='%s', first_name='%s', last_name='%s', password='%s', oauth='%s', profile_pic='%s', city='%s', state='%s', zip_code='%s', roles='%s')>" % (
            self.uuid, self.email, self.username, self.first_name, self.last_name, self.password, self.oauth, self.profile_pic, self.city, self.state, self.zip_code, self.roles)
