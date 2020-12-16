from models.base import Base
from models.person import Person
from models.priority import Priority
from models.role_type import RoleType
from constants import placeholder_image
<<<<<<< HEAD
from sqlalchemy import Column, Enum, String, Integer, Text
# from sqlalchemy.dialects.postgresql import UUID # TODO: Add back when we migrate to Postgresql
from sqlalchemy.dialects.postgresql import ARRAY, JSON
from sqlalchemy.orm import column_property, relationship, synonym
from sqlalchemy.ext.hybrid import hybrid_property
=======
from sqlalchemy import Column, Enum, String, Integer, Text # type: ignore
from sqlalchemy.dialects.postgresql import  UUID, ARRAY, JSON, JSONB # type: ignore
from sqlalchemy.orm import column_property, relationship, synonym # type: ignore
from sqlalchemy.ext.hybrid import hybrid_property # type: ignore
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
from uuid import uuid4

class VolunteerRole(Base):
    __tablename__ = 'volunteer_openings'

<<<<<<< HEAD
    # TODO: Add back when we migrate to Postgresql
    # role_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    # TODO: Remove `primary_key=True` when we migrate to Postgresql and use the uuid as the primary key
    role_external_id = Column('id', String(255), primary_key=True)
    name = Column('position_id', String(255))
    details_url = Column('more_info_link', Text)
    hero_image_urls = Column('team_photo', ARRAY(JSON))
=======
    role_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    role_external_id = Column('id', String(255))
    name = Column('position_id', String(255))
    details_url = Column('more_info_link', Text)
    hero_image_urls = Column('team_photo', JSON)
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
    signup_url = Column('application_signup_form', Text)
    priority = Column('priority_level', Enum(Priority))
    point_of_contact_name = Column('point_of_contact_name', String(255))
    num_openings = Column(Integer, default=1)
    min_time_commitment = Column('minimum_time_commitment_per_week_hours', Integer)
    max_time_commitment = Column('maximum_time_commitment_per_week_hours', Integer)
    overview = Column('job_overview', Text)
    benefits = Column('what_youll_learn', Text)
    responsibilites = Column('responsibilities_and_duties', Text)
    qualifications = Column('qualifications', Text)
    role_type = Column('role_type', Enum(RoleType))

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
        return "<VolunteerRole(role_uuid='%s', role_external_id='%s', name='%s')>" % (
                                self.role_uuid, self.role_external_id, self.name)
