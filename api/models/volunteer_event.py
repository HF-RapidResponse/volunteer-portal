import uuid
from models import Base
from sqlalchemy import Column, String, Integer, Text, DateTime
from sqlalchemy.dialects.postgresql import UUID

class VolunteerEvent(Base):
    __tablename__ = 'events'

    # Todo: Move the UID table to UUID
    event_uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4, unique=True, nullable=False)
    event_external_id = Column('id', Integer)
    name = Column('event_id', String(255))
    # hero_image_url: Url = placeholder_image()
    # 'hero_image_url': {'event_graphics': lambda x: x[0]['url'] if x else None},

    signup_url = Column('signup_link', Text)
    details_url = Column('details_url', Text)
    start_datetime = Column('start', DateTime)
    end_datetime = Column('end', DateTime)
    description = Column('description', Text)
    point_of_contact = Column(Text)

    # def all():
    #     return db().get_linked_model_objects()
        # if not fake_data else generate_fake_volunteer_events_list()

    # def find(id):
    #     return db().get_linked_model_object_for_primary_key(id)
        # if not fake_data else generate_fake_volunteer_event()


# def db():
#     return Dataset(data_source = connections['main'], dataset_key='events', primary_key='id', linked_model=VolunteerEvent, model_key_map=mapping)
