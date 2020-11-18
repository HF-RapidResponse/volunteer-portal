import uuid
from models import Base, RoleType
from sqlalchemy import Column, Enum, String, Integer, Text
from sqlalchemy.dialects.postgresql import UUID

class VolunteerRole(Base):
    __tablename__ = 'volunteer_openings'

    role_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    role_external_id = Column('id', Integer)
    name = Column('position_id', String(255))
    details_url = Column('more_info_link', Text)
    #hero_image_url: Url = placeholder_image()
    # 'hero_image_url': {'team_photo': lambda x: x[0]['url'] if x else None},
    #priority: Priority = Priority.LOW
    # 'priority': {'priority_level': lambda x: x.lower().replace(' ','_')},
    signup_url = Column('application_signup_form', Text)
    point_of_contact = Column(String(255))
    num_openings = Column(Integer, default=1)
    min_time_commitment = Column('minimum_time_commitment_per_week_hours', Integer)
    max_time_commitment = Column('maximum_time_commitment_per_week_hours', Integer)
    overview = Column('job_overview', Text)
    benefits = Column('what_youll_learn', Text)
    responsibilites = Column('responsibilities_and_duties', Text)
    qualifications = Column('qualifications', Text)
    role_type = Column('role_type', Enum(RoleType))

    def __repr__(self):
        return "<VolunteerRole(role_external_id='%s', name='%s')>" % (
                                self.role_external_id, self.name)

    # def all():
    #     db().get_linked_model_objects()
    #     # if not fake_data else generate_fake_volunteer_roles_list()
    #
    # def find(id):
    #     db().get_linked_model_object_for_primary_key(id)
    #     # if not fake_data else generate_fake_volunteer_role()
