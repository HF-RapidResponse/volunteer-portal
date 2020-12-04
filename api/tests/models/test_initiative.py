import pytest
from datetime import datetime
from models import Initiative, VolunteerRole
from settings import Session
from sqlalchemy.orm import lazyload
from tests.fake_data_utils import generate_fake_initiative
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

def test_initiative_create_types(db):
    initiative = generate_fake_initiative(db, 2, 1)
    db.add(initiative)
    new_initiative = db.query(Initiative).filter_by(initiative_external_id=initiative.initiative_external_id).scalar()

    assert new_initiative

    # Validate types
    assert type(new_initiative.initiative_uuid) is UUID
    assert type(new_initiative.initiative_external_id) is str
    assert type(new_initiative.name) is str
    assert type(new_initiative.title) is str
    assert new_initiative.name == new_initiative.title
    assert type(new_initiative.hero_image_url) is str
    assert type(new_initiative.content) is str
    assert type(new_initiative.role_ids) is list
    assert len(new_initiative.role_ids) == 2
    assert len(new_initiative.roles) == 2

    # Validate equality
    assert initiative.name == new_initiative.name
    assert new_initiative.role_ids == initiative.role_ids
    assert type(new_initiative.roles.first()) is VolunteerRole



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
