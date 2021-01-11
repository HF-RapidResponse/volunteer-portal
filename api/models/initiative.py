from constants import placeholder_image
from models.base import Base
from models.volunteer_event import VolunteerEvent
from models.volunteer_role import VolunteerRole
from sqlalchemy import func, select, Column, String, Integer
from sqlalchemy.dialects.postgresql import ARRAY, JSON, UUID
from sqlalchemy.orm import backref, column_property, relationship, synonym
from sqlalchemy.ext.hybrid import hybrid_property
from pydantic import validator
from uuid import uuid4

class Initiative(Base):
    __tablename__ = 'initiatives'

    initiative_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    initiative_external_id = Column('id', String(255))
    name = Column('initiative_name', String(255))
    title = synonym('name')
    details_url = Column('details_link', String(255), nullable=True)
    hero_image_urls = Column('hero_image_urls', ARRAY(JSON))
    content = Column('description', String(255))
    role_ids = Column('roles', ARRAY(String))
    event_ids = Column('events', ARRAY(String))

    def __repr__(self):
        return "<Initiative(initiative_uuid='%s', initiative_external_id='%s', name='%s')>" % (
                                self.initiative_uuid, self.initiative_external_id, self.name)

    @hybrid_property
    def hero_image_url(self):
        return self.hero_image_urls[0]['url'] if self.hero_image_urls else placeholder_image()

    @hybrid_property
    def roles(self):
        return self.roles_rel.filter(VolunteerRole.external_id.in_(self.role_ids)).all()

    @hybrid_property
    def events(self):
        return self.events_rel.filter(VolunteerEvent.external_id.in_(self.event_ids)).all()

# Initiative & Roles
initiaitves_roles_selection = select([func.unnest(Initiative.role_ids).label("role_external_id"), Initiative.initiative_external_id.label("initiative_external_id")]).alias()
# Todo: Figure out how to set roles on an initiative and have them save in the same transaction
Initiative.roles_rel = relationship(VolunteerRole, secondary=initiaitves_roles_selection,
                          primaryjoin=VolunteerRole.external_id == initiaitves_roles_selection.c.role_external_id,
                          secondaryjoin=initiaitves_roles_selection.c.initiative_external_id == Initiative.initiative_external_id,
                          lazy='dynamic',
                          viewonly=True)

VolunteerRole.initiatives_rel = relationship(Initiative, secondary=initiaitves_roles_selection,
                          primaryjoin=VolunteerRole.external_id == initiaitves_roles_selection.c.role_external_id,
                          secondaryjoin=initiaitves_roles_selection.c.initiative_external_id == Initiative.initiative_external_id,
                          # lazy='dynamic',
                          viewonly=True)

# Initiative & Events
initiaitves_events_selection = select([func.unnest(Initiative.event_ids).label("event_external_id"), Initiative.initiative_external_id.label("initiative_external_id")]).alias()
# Todo: Figure out how to set events on an initiative and have them save in the same transaction
Initiative.events_rel = relationship(VolunteerEvent, secondary=initiaitves_events_selection,
                          primaryjoin=VolunteerEvent.external_id == initiaitves_events_selection.c.event_external_id,
                          secondaryjoin=initiaitves_events_selection.c.initiative_external_id == Initiative.initiative_external_id,
                          lazy='dynamic',
                          viewonly=True)

VolunteerEvent.initiatives_rel = relationship(Initiative, secondary=initiaitves_events_selection,
                          primaryjoin=VolunteerEvent.external_id == initiaitves_events_selection.c.event_external_id,
                          secondaryjoin=initiaitves_events_selection.c.initiative_external_id == Initiative.initiative_external_id,
                          # lazy='dynamic',
                          viewonly=True)
