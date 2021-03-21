import pytest
from typing import List
from uuid import UUID
from datetime import datetime

from fastapi.testclient import TestClient
from pydantic import error_wrappers

from api.api import app
from settings import Session

from schemas import NestedInitiativeSchema, InitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema
from models import NestedInitiative, Initiative, VolunteerRole, VolunteerEvent, DonationEmail

from tests.fake_data_utils import generate_fake_initiative, generate_fake_volunteer_role
from tests.fake_data_utils import generate_fake_volunteer_event
from tests.fake_data_utils import generate_fake_initiatives_list

from sqlalchemy import exc

@pytest.fixture
def db():
    return Session()

# Will run each test in the `yield` portion
@pytest.fixture(autouse=True)
def setup(db):
    db = Session()
    yield # this is where the testing happens
    db.rollback()

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
    initiatives_response = [InitiativeSchema(**initiative_kwargs) for initiative_kwargs in json]
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

def test_create_link_request_error():
    with pytest.raises(error_wrappers.ValidationError):
        bad_link_request_kwargs = {
            "email": "name@gmail"
        }
        DonationEmailSchema(**bad_link_request_kwargs)

def test_create_link_request_error():
    good_link_request_kwargs = {
        "email": "name@gmail.com"
    }
    good_request = DonationEmailSchema(**good_link_request_kwargs)
    assert good_request
    assert type(good_request) is DonationEmailSchema
    assert good_request.email == 'name@gmail.com'

def set_nullable_columns_null(db_row, db):
  # Adds column to the DB, and sets all nullable rows to None
  db_row_dict = db_row.__dict__.copy()
  db.add(db_row)
  db.commit()

  fields = [x for x in db_row_dict if not x.startswith('_sa_')]
  for a in fields:
    try:
      setattr(db_row, a, None)
      r = db.commit()
    except Exception as e:
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

  client.get(f'api/volunteer_initiatives/{initiative.external_id}')
  cleanup_initiative(db, initiative)
