from constants import placeholder_image
from models.person import Person
from models.base import Base
from sqlalchemy import Column, String, Integer, Text, DateTime
from sqlalchemy.dialects.postgresql import UUID, ARRAY, JSON
from sqlalchemy.ext.hybrid import hybrid_property
from uuid import uuid4

class VolunteerEvent(Base):
    __tablename__ = 'events'

    event_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    event_external_id = Column('id', String(255))
    name = Column('event_id', String(255))
    hero_image_urls = Column('event_graphics', JSON)
    signup_url = Column('signup_link', Text)
    details_url = Column('details_url', Text)
    start_datetime = Column('start', DateTime)
    end_datetime = Column('end', DateTime)
    description = Column('description', Text)
    point_of_contact_name = Column('point_of_contact_name', Text)

    @hybrid_property
    def hero_image_url(self):
        return self.hero_image_urls[0]['url'] if self.hero_image_urls else placeholder_image()

    @hybrid_property
    def point_of_contact(self):
        return Person(name=self.name)

    def __repr__(self):
        return "<VolunteerEvent(event_uuid='%s', event_external_id='%s', name='%s')>" % (
                                self.event_uuid, self.event_external_id, self.name)
