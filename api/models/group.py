from models.base import Base

from uuid import uuid4
from sqlalchemy import Column, String, Text, Boolean
from sqlalchemy.dialects.postgresql import UUID, JSON


class Group(Base):
    __tablename__ = 'groups'

    uuid = Column(UUID(as_uuid=True), primary_key=True,
                  default=uuid4, unique=True, nullable=False)
    group_name = Column('group_name', String(128), unique=True, nullable=False)

    # A short description of the groups location. E.g. Washington State, National Group, or Remote
    location_description = Column('location_description', String(128), nullable=True)
    description = Column('description', Text, nullable=True)

    zip_code = Column('zip_code', String(32), nullable=True)

    approved_public = Column('approved_public', Boolean, nullable=False, default=False)

    # A map of social media names to links. e.g. {"Facebook": "www.facebook.com/yang_gang_nyc"}
    social_media_links = Column('social_media_links', JSON, default={}, nullable=False)

    def __repr__(self):
        return "<Group(uuid='%s', group_name='%s')>" % (
            self.uuid, self.group_name)
