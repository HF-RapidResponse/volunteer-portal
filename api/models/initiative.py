import uuid
from constants import placeholder_image
from models.base import Base
<<<<<<< HEAD
from models.volunteer_role import VolunteerRole
from sqlalchemy import func, select, Column, String, Integer
# from sqlalchemy.dialects.postgresql import UUID # TODO: Add back when we migrate to Postgresql
from sqlalchemy.dialects.postgresql import UUID, ARRAY, JSON
from sqlalchemy.orm import backref, column_property, relationship, synonym
from sqlalchemy.ext.hybrid import hybrid_property
=======
from models.volunteer_event import VolunteerEvent
from models.volunteer_role import VolunteerRole
from sqlalchemy import func, select, Column, String, Integer # type: ignore
from sqlalchemy.dialects.postgresql import UUID, ARRAY, JSON # type: ignore
from sqlalchemy.orm import backref, column_property, relationship, synonym # type: ignore
from sqlalchemy.ext.hybrid import hybrid_property # type: ignore
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
from pydantic import validator

class Initiative(Base):
    __tablename__ = 'initiatives'

<<<<<<< HEAD
    # TODO: Add back when we migrate to Postgresql
    # initiative_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    # TODO: Remove `primary_key=True` when we migrate to Postgresql and use the uuid as the primary key
    initiative_external_id = Column('id', String(255), primary_key=True)
    name = Column('initiative_name', String(255))
    title = synonym('name')
    details_url = Column('details_link', String(255), nullable=True)
    hero_image_urls = Column('hero_image_urls', ARRAY(JSON))
=======
    initiative_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    initiative_external_id = Column('id', String(255))
    name = Column('initiative_name', String(255))
    details_url = Column('details_link', String(255), nullable=True)
    hero_image_urls = Column('hero_image_urls', JSON)
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
    content = Column('description', String(255))
    role_ids = Column('roles', ARRAY(String))
    event_ids = Column('events', ARRAY(String))

<<<<<<< HEAD

    # Todo
    # events = relationship('events', "VolunteerEvent")
=======
    # Todo
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
    # highlightedItems = relationship('events', "VolunteerEvent")
    # highlightedItems: List[Union[VolunteerRole,VolunteerEvent]] = []

    def __repr__(self):
        return "<Initiative(initiative_uuid='%s', initiative_external_id='%s', name='%s')>" % (
                                self.initiative_uuid, self.initiative_external_id, self.name)

<<<<<<< HEAD
    # TODO: Remove when we migrate to Postgresql
    @hybrid_property
    def initiative_uuid(self):
        return uuid.uuid4

=======
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
    @hybrid_property
    def hero_image_url(self):
        return self.hero_image_urls[0]['url'] if self.hero_image_urls else placeholder_image()

    @hybrid_property
    def roles(self):
<<<<<<< HEAD
        found_roles = self.roles_rel.filter_by(VolunteerRole.role_external_id.in_(self.role_ids)).all()
        print(f'IDS LENGTH: {len(self.role_ids)} / ROLES LENGTH: {len(found_roles)}')
        return found_roles



initiaitves_roles_selection = select([func.unnest(Initiative.role_ids).label("role_external_id"), Initiative.initiative_external_id.label("initiative_external_id")]).alias()
# Todo: Figure out how to set roles on an initiative and have them save in the same transaction
Initiative.roles_rel = relationship(VolunteerRole, secondary=initiaitves_roles_selection,
                          primaryjoin=VolunteerRole.role_external_id == initiaitves_roles_selection.c.role_external_id,
                          secondaryjoin=initiaitves_roles_selection.c.initiative_external_id == Initiative.initiative_external_id,
                          lazy='dynamic',
                          viewonly=True)

VolunteerRole.initiatives_rel = relationship(Initiative, secondary=initiaitves_roles_selection,
                          primaryjoin=VolunteerRole.role_external_id == initiaitves_roles_selection.c.role_external_id,
                          secondaryjoin=initiaitves_roles_selection.c.initiative_external_id == Initiative.initiative_external_id,
=======
        if not self.role_ids:
            return []
        return self.roles_rel.filter(VolunteerRole.role_external_id.in_(self.role_ids)).all()

    @hybrid_property
    def events(self):
        if not self.event_ids:
            return []
        return self.events_rel.filter(VolunteerEvent.event_external_id.in_(self.event_ids)).all()

    
roles_to_initiative_mapping = select(
    [func.unnest(Initiative.role_ids).label("role_external_id"),
     Initiative.initiative_external_id.label("initiative_external_id")]).alias()
# Todo: Figure out how to set roles on an initiative and have them save in the same transaction
Initiative.roles_rel = relationship(VolunteerRole, secondary=roles_to_initiative_mapping,
                          primaryjoin=VolunteerRole.role_external_id == roles_to_initiative_mapping.c.role_external_id,
                          secondaryjoin=roles_to_initiative_mapping.c.initiative_external_id == Initiative.initiative_external_id,
                          lazy='dynamic',
                          viewonly=True)

events_to_initiative_mapping = select(
    [func.unnest(Initiative.event_ids).label("event_external_id"),
     Initiative.initiative_external_id.label("initiative_external_id")]).alias()
# Todo: Figure out how to set events on an initiative and have them save in the same transaction
Initiative.events_rel = relationship(VolunteerEvent, secondary=events_to_initiative_mapping,
                          primaryjoin=VolunteerEvent.event_external_id == events_to_initiative_mapping.c.event_external_id,
                          secondaryjoin=events_to_initiative_mapping.c.initiative_external_id == Initiative.initiative_external_id,
                          lazy='dynamic',
                          viewonly=True)

# TODO give roles and events access to initiatives
VolunteerRole.initiatives_rel = relationship(Initiative, secondary=roles_to_initiative_mapping,
                          primaryjoin=VolunteerRole.role_external_id == roles_to_initiative_mapping.c.role_external_id,
                          secondaryjoin=roles_to_initiative_mapping.c.initiative_external_id == Initiative.initiative_external_id,
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
                          # lazy='dynamic',
                          viewonly=True)
