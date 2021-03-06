import pytest
from datetime import datetime
from models import VolunteerEvent, Person
from settings import Session
from tests.fake_data_utils import generate_fake_volunteer_event
from uuid import UUID

@pytest.fixture
def db():
    return Session()


# Will run each test in the `yield` portion
@pytest.fixture(autouse=True)
def setup(db):
    db = Session()
    yield # this is where the testing happens
    db.rollback()

def test_volunteer_event_create_types(db):
    event = generate_fake_volunteer_event()
    db.add(event)
    new_event = db.query(VolunteerEvent).filter_by(external_id=event.external_id).scalar()

    assert new_event

    # Validate types
    # TODO: Add back when we migrate to Postgresql
    assert type(new_event.uuid) is UUID # todo
    assert type(new_event.external_id) is str
    assert type(new_event.event_name) is str
    assert type(new_event.signup_url) is str
    assert type(new_event.hero_image_url) is str
    assert type(new_event.start_datetime) is datetime
    assert type(new_event.end_datetime) is datetime
    assert type(new_event.description) is str
    assert type(new_event.airtable_last_modified) is datetime
    assert type(new_event.updated_at) is datetime
    assert type(new_event.is_deleted) is bool

    # Validate equality
    assert event.event_name == new_event.event_name


