from constants import placeholder_image
from models import Base
from sqlalchemy import Column, String, Integer, Text, DateTime, Boolean
from sqlalchemy.dialects.postgresql import ARRAY, JSON, UUID
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.sql import func
from uuid import uuid4

class VolunteerEvent(Base):
    __tablename__ = 'events'

    uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    external_id = Column('id', String(255), nullable=False)
    event_name = Column('event_name', String(255), nullable=False)
    hero_image_urls = Column('event_graphics', ARRAY(JSON))
    signup_url = Column('signup_link', Text)
    start_datetime = Column('start', DateTime)
    end_datetime = Column('end', DateTime)
    description = Column('description', Text)
    airtable_last_modified = Column('airtable_last_modified', DateTime, nullable=False)
    updated_at = Column('updated_at', DateTime, onupdate=func.now(), default=func.now(), nullable=False)
    is_deleted = Column('is_deleted', Boolean, nullable=False, default=False)
    
    @hybrid_property
    def hero_image_url(self):
        return self.hero_image_urls[0]['url'] if self.hero_image_urls else placeholder_image()

    def __repr__(self):
        return "<VolunteerEvent(uuid='%s', external_id='%s', name='%s')>" % (
                                self.uuid, self.external_id, self.event_name)
