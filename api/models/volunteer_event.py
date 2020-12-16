from constants import placeholder_image
<<<<<<< HEAD
from models import Base, Person
from sqlalchemy import Column, String, Integer, Text, DateTime
# from sqlalchemy.dialects.postgresql import UUID # TODO: Add back when we migrate to Postgresql
from sqlalchemy.dialects.postgresql import ARRAY, JSON
from sqlalchemy.ext.hybrid import hybrid_property
=======
from models.person import Person
from models.base import Base
from sqlalchemy import Column, String, Integer, Text, DateTime # type: ignore
from sqlalchemy.dialects.postgresql import UUID, ARRAY, JSON # type: ignore
from sqlalchemy.ext.hybrid import hybrid_property # type: ignore
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
from uuid import uuid4

class VolunteerEvent(Base):
    __tablename__ = 'events'

<<<<<<< HEAD
    # TODO: Add back when we migrate to Postgresql
    # event_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    # TODO: Remove `primary_key=True` when we migrate to Postgresql and use the uuid as the primary key
    event_external_id = Column('id', String(255), primary_key=True)
    name = Column('event_id', String(255))
    hero_image_urls = Column('event_graphics', ARRAY(JSON))
=======
    event_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    event_external_id = Column('id', String(255))
    name = Column('event_id', String(255))
    hero_image_urls = Column('event_graphics', JSON)
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
    signup_url = Column('signup_link', Text)
    details_url = Column('details_url', Text)
    start_datetime = Column('start', DateTime)
    end_datetime = Column('end', DateTime)
    description = Column('description', Text)
    point_of_contact_name = Column('point_of_contact_name', Text)

<<<<<<< HEAD
    # TODO: Remove when we migrate to Postgresql
    @hybrid_property
    def initiative_uuid(self):
        return uuid4

=======
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
    @hybrid_property
    def hero_image_url(self):
        return self.hero_image_urls[0]['url'] if self.hero_image_urls else placeholder_image()

    @hybrid_property
    def point_of_contact(self):
<<<<<<< HEAD
        return Person(name=self.name)
=======
        return Person(name=self.point_of_contact_name) if self.point_of_contact_name else None
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100

    def __repr__(self):
        return "<VolunteerEvent(event_uuid='%s', event_external_id='%s', name='%s')>" % (
                                self.event_uuid, self.event_external_id, self.name)
