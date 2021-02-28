from constants import placeholder_image
from models import Base
from models.airtable_row import AirtableRow
from sqlalchemy import Column, String, Text, DateTime
from sqlalchemy.dialects.postgresql import ARRAY, JSON, UUID
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.sql import func
from uuid import uuid4

class VolunteerEvent(AirtableRow, Base):
    __tablename__ = 'events'

    uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    event_name = Column('event_name', String(255), nullable=False)
    hero_image_urls = Column('event_graphics', ARRAY(JSON))
    signup_url = Column('signup_link', Text, nullable=False)
    start_datetime = Column('start', DateTime, nullable=False)
    end_datetime = Column('end', DateTime)
    description = Column('description', Text)

    @hybrid_property
    def hero_image_url(self):
        return self.hero_image_urls[0]['url'] if self.hero_image_urls else placeholder_image()

    def __repr__(self):
        return "VolunteerEvent(uuid='%s', external_id='%s', name='%s')" % (
                                self.uuid, self.external_id, self.event_name)
