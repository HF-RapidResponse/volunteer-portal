from constants import placeholder_image
from models import Base, Person
from sqlalchemy import Column, String, Integer, Text, DateTime
# from sqlalchemy.dialects.postgresql import UUID # TODO: Add back when we migrate to Postgresql
from sqlalchemy.dialects.postgresql import ARRAY, JSON
from sqlalchemy.ext.hybrid import hybrid_property
from uuid import uuid4

class VolunteerEvent(Base):
    __tablename__ = 'events'

    # TODO: Add back when we migrate to Postgresql
    # event_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    # TODO: Remove `primary_key=True` when we migrate to Postgresql and use the uuid as the primary key
    event_external_id = Column('id', String(255), primary_key=True)
    name = Column('event_id', String(255))
    hero_image_urls = Column('event_graphics', ARRAY(JSON))
    signup_url = Column('signup_link', Text)
    details_url = Column('details_url', Text)
    start_datetime = Column('start', DateTime)
    end_datetime = Column('end', DateTime)
    description = Column('description', Text)
    point_of_contact_name = Column('point_of_contact_name', Text)

    # TODO: Remove when we migrate to Postgresql
    @hybrid_property
    def initiative_uuid(self):
        return uuid4

    @hybrid_property
    def hero_image_url(self):
        return self.hero_image_urls[0]['url'] if self.hero_image_urls else placeholder_image()

    @hybrid_property
    def point_of_contact(self):
        return Person(name=self.name)

    def __repr__(self):
        return "<VolunteerEvent(event_uuid='%s', event_external_id='%s', name='%s')>" % (
                                self.event_uuid, self.event_external_id, self.name)
