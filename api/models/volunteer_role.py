from models.base import Base
from models.person import Person
from models.priority import Priority
from models.role_type import RoleType
from constants import placeholder_image
from sqlalchemy import Column, Enum, String, Integer, Text
from sqlalchemy.dialects.postgresql import UUID, ARRAY, JSON
from sqlalchemy.orm import column_property, relationship, synonym
from sqlalchemy.ext.hybrid import hybrid_property
import uuid

class VolunteerRole(Base):
    __tablename__ = 'volunteer_openings'

    role_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    role_external_id = Column('id', String(255))
    name = Column('position_id', String(255))
    details_url = Column('more_info_link', Text)
    hero_image_urls = Column('team_photo', ARRAY(JSON))
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

    @hybrid_property
    def hero_image_url(self):
        return self.hero_image_urls[0]['url'] if self.hero_image_urls else placeholder_image()

    @hybrid_property
    def point_of_contact(self):
        return Person(name=self.name)

    def __repr__(self):
        return "<VolunteerRole(role_uuid='%s', role_external_id='%s', name='%s')>" % (
                                self.role_uuid, self.role_external_id, self.name)
