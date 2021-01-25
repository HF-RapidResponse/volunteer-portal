import pytest
from datetime import datetime
from models import VolunteerEvent, Person
from settings import Session
from tests.fake_data_utils import generate_fake_volunteer_event
# TODO: Add back when we migrate to Postgresql
# from uuid import UUID

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
    new_event = db.query(VolunteerEvent).filter_by(event_external_id=event.event_external_id).scalar()

    assert new_event

    # Validate types
    # TODO: Add back when we migrate to Postgresql
    # assert type(new_event.event_uuid) is UUID # todo
    assert type(new_event.event_external_id) is str
    assert type(new_event.name) is str
    assert type(new_event.signup_url) is str
    assert type(new_event.hero_image_url) is str
    assert type(new_event.details_url) is str
<<<<<<< HEAD
    assert type(new_event.point_of_contact) is Person or new_event.point_of_contact is None
=======
    assert type(new_event.point_of_contact) is Person
>>>>>>> develop
    assert type(new_event.start_datetime) is datetime
    assert type(new_event.end_datetime) is datetime
    assert type(new_event.description) is str

    # Validate equality
    assert event.name == new_event.name



# def test_volunteer_role_attributes():



# def test_volunteer_role_list_result():
#
#     query_results = db.query(VolunteerRole).all()
#     assert type(query_results) is ResultProxy
#
#     row = query_results.fetchone()
#     assert row
#     assert type(row['AirtableData.events_event_id']) is str
#     assert type(row['AirtableData.events_start']) is datetime
