import pytest
from datetime import datetime
from models import Initiative, NestedInitiative, VolunteerRole, VolunteerEvent
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
    initiative = generate_fake_initiative(db, 2, 3)
    db.add(initiative)
    new_initiative = db.query(NestedInitiative).filter_by(external_id=initiative.external_id).scalar()

    assert new_initiative

    # Validate types
    assert type(new_initiative.uuid) is UUID
    assert type(new_initiative.external_id) is str
    assert type(new_initiative.initiative_name) is str
    assert type(new_initiative.hero_image_url) is str
    assert type(new_initiative.content) is str

    # Validate Role
    assert type(new_initiative.role_ids) is list
    assert len(new_initiative.role_ids) == 2
    assert len(new_initiative.roles) == 2
    assert type(new_initiative.roles[0]) is VolunteerRole

    # Validate Event
    assert type(new_initiative.event_ids) is list
    assert len(new_initiative.event_ids) == 3
    assert len(new_initiative.events) == 3
    assert type(new_initiative.events[0]) is VolunteerEvent

    # Validate equality
    assert initiative.initiative_name == new_initiative.initiative_name
    assert new_initiative.role_ids == initiative.role_ids
    assert new_initiative.event_ids == initiative.event_ids


def test_initiatives_relationships_scoped(db):
    initiative = generate_fake_initiative(db, 5, 5)
    db.add(initiative)

    initiative = generate_fake_initiative(db, 2, 3)
    db.add(initiative)
    new_initiative = db.query(NestedInitiative).filter_by(external_id=initiative.external_id).scalar()

    assert len(new_initiative.role_ids) == 2
    assert len(new_initiative.roles) == 2

    assert len(new_initiative.event_ids) == 3
    assert len(new_initiative.events) == 3

def test_initiative_default_image(db):
    initiative = generate_fake_initiative(db, 2, 3)
    initiative.hero_image_urls = None
    db.add(initiative)

    new_initiative = db.query(Initiative).filter_by(external_id=initiative.external_id).first()

    assert new_initiative.hero_image_url and "https://" in new_initiative.hero_image_url
