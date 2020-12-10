import pytest
from models import VolunteerRole, Person, Priority, RoleType
from settings import Session
from typing import List
from tests.fake_data_utils import generate_fake_volunteer_role
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

def test_volunteer_role_create_types(db):
    role = generate_fake_volunteer_role()
    db.add(role)
    new_role = db.query(VolunteerRole).filter_by(role_external_id=role.role_external_id).scalar()

    assert new_role

    # Validate types
    assert type(new_role.role_uuid) is UUID 
    assert type(new_role.role_external_id) is str
    assert type(new_role.name) is str
    assert type(new_role.details_url) is str
    assert type(new_role.hero_image_url) is str
    assert type(new_role.priority) is Priority
    assert type(new_role.point_of_contact) is Person or new_role.point_of_contact is None
    assert type(new_role.num_openings) is int
    assert type(new_role.min_time_commitment) is int
    assert type(new_role.max_time_commitment) is int
    assert type(new_role.overview) is str
    assert type(new_role.benefits) is str
    assert type(new_role.responsibilites) is str
    assert type(new_role.qualifications) is str
    assert type(new_role.role_type) is RoleType

    # Validate equality
    assert role.name == new_role.name



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
