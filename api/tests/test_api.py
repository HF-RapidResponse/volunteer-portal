import pytest
from typing import List
from uuid import UUID
from datetime import datetime

from fastapi.testclient import TestClient
from pydantic import error_wrappers

from api.api import app
from settings import Session

from schemas import NestedInitiativeSchema, InitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema
from models import NestedInitiative, Initiative, VolunteerRole, VolunteerEvent

from tests.fake_data_utils import generate_fake_initiative, generate_fake_volunteer_role
from tests.fake_data_utils import generate_fake_volunteer_event, generate_fake_volunteer_events_list
from tests.fake_data_utils import generate_fake_initiatives_list, run_delete

from sqlalchemy import exc


@pytest.fixture
def db():
    return Session()

# Will run each test in the `yield` portion


@pytest.fixture(autouse=True)
def setup(db):
    db = Session()
    yield  # this is where the testing happens
    db.rollback()
    run_delete(NestedInitiative, db)
    run_delete(Initiative, db)
    run_delete(VolunteerRole, db)
    run_delete(VolunteerEvent, db)

client = TestClient(app)


def cleanup_initiative(db, initiative):
    for item in initiative.roles + initiative.events:
        db.delete(item)
    db.delete(initiative)
    db.commit()


def test_create_model():
    good_event_kwargs = {
        "uuid": "3457f844-5a3a-4efe-b16d-443c24961c68",
        "external_id": "Medical too same money gas director rule.",
        "event_name": "Medical too same money gas director rule.",
        "details_url": "https://time.ca/interest/people.html",
        "hero_image_url": "https://hill.com/category/about.html",
        "start_datetime": "2020-10-25T15:19:51.824283",
        "end_datetime": "2020-11-02T15:19:51.824283",
        "description": "Early sign page pretty heart bring share. Television research agency minute fine Mr together. Each treat strategy director. Detail million guess someone base for upon.",
        "point_of_contact": None,
        "signup_url": "https://moreno.com/post.htm"
    }

    good_event = VolunteerEventSchema(**good_event_kwargs)

    assert good_event
    assert type(good_event) is VolunteerEventSchema
    assert type(good_event.uuid) is UUID
    assert type(good_event.end_datetime) is datetime


def test_create_model_error():
    with pytest.raises(error_wrappers.ValidationError):
        bad_event_kwargs = {
            "uuid": 1234,
            "external_id": "Medical too same money gas director rule.",
            "hero_image_url": "https://hill.com/category/about.html",
            "start_datetime": "2020-10-25T15:19:51.824283",
            "description": "Early sign page pretty heart bring share. Television research agency minute fine Mr together. Each treat strategy director. Detail million guess someone base for upon.",
            "point_of_contact": None,
            "sign_up_link": "https://moreno.com/post.htm"
        }

        _ = VolunteerEventSchema(**bad_event_kwargs)


def test_get_initiatives_api(db):
    initiatives = generate_fake_initiatives_list(db)
    db.commit()
    response = client.get('api/initiatives')
    json = response.json()
    assert response.status_code == 200

    assert len(json) == 1
    initiative_json = json[0]
    assert 'roles' not in initiative_json and 'events' not in initiative_json
    initiatives_response = [InitiativeSchema(
        **initiative_kwargs) for initiative_kwargs in json]
    assert type(initiatives_response[0]) is InitiativeSchema
    assert not hasattr(initiatives_response[0], 'roles',)
    assert not hasattr(initiatives_response[0], 'events',)
    [cleanup_initiative(db, i) for i in initiatives]


def test_get_initiative_api(db):
    # because Initiatives contain VolunteerEvents and VolunteerRoles, this will test field validations on all three models
    initiative = generate_fake_initiative(db)
    db.add(initiative)
    db.commit()
    initiative_id = initiative.external_id

    response = client.get(f'api/initiatives/{initiative_id}')

    initiative_json = response.json()
    assert response.status_code == 200
    assert 'roles' in initiative_json and 'events' in initiative_json

    initiatives_response = NestedInitiativeSchema(**initiative_json)
    assert type(initiatives_response) is NestedInitiativeSchema
    assert hasattr(initiatives_response, 'roles')
    assert hasattr(initiatives_response, 'events')

    cleanup_initiative(db, initiative)


def set_nullable_columns_null(db_row, db):
    # Adds column to the DB, and sets all nullable rows to None
    db_row_dict = db_row.__dict__.copy()
    db.add(db_row)
    db.commit()

    fields = [x for x in db_row_dict if not x.startswith('_sa_')]
    for a in fields:
        try:
            setattr(db_row, a, None)
            db.commit()
        except Exception:
            db.rollback()


def test_nullified_event_serving(db):
    event = generate_fake_volunteer_event()
    set_nullable_columns_null(event, db)

    client.get(f'api/volunteer_events/{event.external_id}')
    db.delete(event)
    db.commit()


def test_nullified_roles_serving(db):
    role = generate_fake_volunteer_role()
    set_nullable_columns_null(role, db)

    client.get(f'api/volunteer_roles/{role.external_id}')
    db.delete(role)
    db.commit()


def test_nullified_initiatives_serving(db):
    initiative = generate_fake_initiative(db)
    set_nullable_columns_null(initiative, db)

    resp = client.get(f'api/initiatives/{initiative.external_id}')
    assert resp.status_code < 400

    cleanup_initiative(db, initiative)

def test_sync_events_test_route(db):
    saved_test_events = db.query(VolunteerEvent).filter(VolunteerEvent.external_id.like("%_test")).all()
    assert len(saved_test_events) == 0


    resp = client.get(f'api/run_test_event_sync')

    saved_test_events = db.query(VolunteerEvent).filter(VolunteerEvent.external_id.like("%_test"))
    assert len(saved_test_events.all()) == 3
    assert "Sync Complete. Issues Found <b>0</b>" in resp.text

    for e in saved_test_events:
        db.delete(e)
    db.commit()


def check_events_ordered(event_list):
    last = None
    for event in event_list:
        assert last is None or event['start_datetime'] >= last
        last = event['start_datetime']

def test_volunteer_event_create_types(db):
    events = generate_fake_volunteer_events_list(db, 10)
    db.commit()

    resp = client.get(f'api/volunteer_events')
    events_response = resp.json()
    assert len(events_response) == 10

    check_events_ordered(events_response)

    db.query(VolunteerEvent).delete()
    db.commit()

def test_events_ordered_in_initiatives(db):
    db_initiatives = generate_fake_initiatives_list(db, count=4, events_count = 10)
    db.commit()

    initiatives = client.get(f'api/initiatives').json()

    for initiative in initiatives:
        uuid = initiative['external_id']
        full_initiative = client.get(f'api/initiatives/{uuid}').json()
        events = full_initiative['events']
        check_events_ordered(events)

    for i in db_initiatives:
        cleanup_initiative(db, i)
