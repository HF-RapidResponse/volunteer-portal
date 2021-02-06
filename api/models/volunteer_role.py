from models.base import Base
from models.airtable_row import AirtableRow
from models.person import Person
from models.priority import Priority
from models.role_type import RoleType
from constants import placeholder_image
from sqlalchemy import Column, Enum, String, Integer, Text
from sqlalchemy.dialects.postgresql import ARRAY, JSON, UUID
from sqlalchemy.orm import column_property, relationship, synonym
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.sql import func
from uuid import uuid4

class VolunteerRole(AirtableRow, Base):
    __tablename__ = 'volunteer_openings'

    uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    role_name = Column('role_name', String(255), nullable=False)
    hero_image_urls = Column('hero_image_urls', ARRAY(JSON))
    signup_url = Column('application_signup_form', Text)
    details_url = Column('more_info_link', Text)    
    priority = Column('priority', Enum(Priority), nullable=False)
    team = Column('team', ARRAY(String(255)))
    team_lead_ids = Column('team_lead_ids', ARRAY(String(255)))
    num_openings = Column(Integer, default=1)
    min_time_commitment = Column('minimum_time_commitment_per_week_hours', Integer)
    max_time_commitment = Column('maximum_time_commitment_per_week_hours', Integer)
    overview = Column('job_overview', Text)
    benefits = Column('what_youll_learn', Text)
    responsibilities = Column('responsibilities_and_duties', Text)
    qualifications = Column('qualifications', Text)
    role_type = Column('role_type', Enum(RoleType), nullable=False)

    @hybrid_property
    def hero_image_url(self):
        return self.hero_image_urls[0]['url'] if self.hero_image_urls else placeholder_image()

    def __repr__(self):
        return "<VolunteerRole(role_uuid='%s', role_external_id='%s', name='%s')>" % (
                                self.uuid, self.external_id, self.role_name)
