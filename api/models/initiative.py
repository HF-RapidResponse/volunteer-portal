import uuid
from constants import placeholder_image
from models.base import Base
from models.volunteer_role import VolunteerRole
from sqlalchemy import Column, String, Integer
from sqlalchemy.dialects.postgresql import UUID, ARRAY, JSON
from sqlalchemy.orm import column_property, relationship, synonym
from sqlalchemy.ext.hybrid import hybrid_property

class Initiative(Base):
    __tablename__ = 'initiatives'

    initiative_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    initiative_external_id = Column('id', String(255))
    name = Column('initiative_name', String(255))
    title = synonym('name')
    details_url = Column('details_link', String(255), nullable=True)
    hero_image_urls = Column('hero_image_urls', ARRAY(JSON))
    content = Column('description', String(255))

    role_ids = Column('roles', ARRAY(String))


    # Todo
    # events = relationship('events', "VolunteerEvent")
    # highlightedItems = relationship('events', "VolunteerEvent")
    # highlightedItems: List[Union[VolunteerRole,VolunteerEvent]] = []

    def __repr__(self):
        return "<Initiative(initiative_uuid='%s', initiative_external_id='%s', name='%s')>" % (
                                self.initiative_uuid, self.initiative_external_id, self.name)

    @hybrid_property
    def hero_image_url(self):
        return self.hero_image_urls[0]['url'] if self.hero_image_urls else placeholder_image()


from sqlalchemy import *
from sqlalchemy.dialects import postgresql
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import *
initiaitves_roles_selection = select([func.unnest(Initiative.role_ids).label("role_external_id"), Initiative.initiative_external_id.label("initiative_external_id")]).alias()
# Todo: Figure out how to set roles on an initiative and have them save in the same transaction
Initiative.roles = relationship(VolunteerRole, secondary=initiaitves_roles_selection,
                          primaryjoin=VolunteerRole.role_external_id == initiaitves_roles_selection.c.role_external_id,
                          secondaryjoin=initiaitves_roles_selection.c.initiative_external_id == Initiative.initiative_external_id,
                          lazy='dynamic',
                          viewonly=True)

VolunteerRole.initiatives = relationship(Initiative, secondary=initiaitves_roles_selection,
                          primaryjoin=VolunteerRole.role_external_id == initiaitves_roles_selection.c.role_external_id,
                          secondaryjoin=initiaitves_roles_selection.c.initiative_external_id == Initiative.initiative_external_id,
                          lazy='dynamic',
                          viewonly=True)
