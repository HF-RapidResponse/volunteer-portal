import uuid
from models.base import Base
from sqlalchemy import Column, String, Integer
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import column_property, relationship, synonym

class Initiative(Base):
    __tablename__ = 'initiatives'

    initiative_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    initiative_external_id = Column('id', String(255))
    name = Column('initiative_name', String(255))
    details_url = Column('details_link', String(255), nullable=True)
    title = synonym("name")

    # image = Column('image', )
    # hero_image_url
    content = Column('description', String(255))
    # roles = relationship('volunteer_openings', "VolunteerRole")
    # events = relationship('events', "VolunteerEvent")

    # Todo
    # highlightedItems = relationship('events', "VolunteerEvent")
    # highlightedItems: List[Union[VolunteerRole,VolunteerEvent]] = []

    # def all():
    #     return db().get_linked_model_objects() #if not fake_data else generate_fake_initiatives_list()
    #
    # def find(id):
    #     return db().get_linked_model_object_for_primary_key(id)

        # initiatives_dataset.get_linked_model_object_for_primary_key(initiative_external_id) if not fake_data else generate_fake_initiative() # type: ignore

# def db():
#     return Dataset(data_source = connections['main'], dataset_key='initiatives', primary_key='id', linked_model=Initiative, model_key_map=mapping)
