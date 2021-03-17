import pytest
from typing import List
from uuid import UUID
from datetime import datetime

from fastapi.testclient import TestClient
from pydantic import error_wrappers

from api.api import app
from settings import Session

from schemas import InitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema
from models import Initiative, VolunteerRole, VolunteerEvent

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
    yield  # this is where the testing happens
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
    # because Initiatives contain VolunteerEvents and VolunteerRoles, this will test field validations on all three models
    initiatives = generate_fake_initiatives_list(db)
    db.commit()
    response = client.get('api/initiatives')
    json = response.json()
    assert response.status_code == 200

    assert len(json) == 1
    initiatives_response = [InitiativeSchema(
        **initiative_kwargs) for initiative_kwargs in json]
    assert type(initiatives_response[0]) is InitiativeSchema

    [cleanup_initiative(db, i) for i in initiatives]


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


def test_create_account(db):
    account = {'email': 'rebecca03@thomasrivera.com',
               'username': 'DakotaMcclain',
               'first_name': 'Jeff',
               'last_name': 'Long',
               'password': '^7^Cg&kt*X',
               'oauth': 'W^9Oa(Qy+L',
               'profile_pic': 'http://www.davis-burke.com/',
               'city': 'Lake Robertburgh',
               'state': 'Virginia',
               'zip_code': '20101',
               'roles': ['Sales professional,IT',
                         'Commissioning editor']}
    response = client.post(f'api/accounts/', json=account)
    assert response.status_code < 400

    response_account = response.json()
    assert 'uuid' in response_account
    uuid = response_account['uuid']

    resp = client.get(f'api/accounts/{uuid}')
    response_account = resp.json()

    del_resp = client.delete(f'api/accounts/{uuid}')
    assert del_resp.status_code < 400

    # check db_saved password is encrypted
    assert response_account['password'] != account['password']

    del response_account['password']
    del account['password']
    del response_account['uuid']

    assert response_account == account


def test_create_duplicate_email_account(db):
    account = {'email': 'rebecca03@thomasrivera.com',
               'username': 'DakotaMcclain',
               'first_name': 'Jeff',
               'last_name': 'Long',
               'password': '^7^Cg&kt*X',
               'oauth': 'W^9Oa(Qy+L',
               'profile_pic': 'http://www.davis-burke.com/',
               'city': 'Lake Robertburgh',
               'state': 'Virginia',
               'zip_code': '20101',
               'roles': ['Sales professional,IT',
                         'Commissioning editor']}
    account2 = {'email': 'rebecca03@thomasrivera.com',
                'username': 'DakotaMcclain2',
                'first_name': 'Jeff2',
                'last_name': 'Long2',
                'password': '^7^Cg&kt*X2',
                'oauth': 'W^9Oa(Qy+L2',
                'profile_pic': 'http://www.davis-burke.com/2',
                'city': 'Lake Robertburgh2',
                'state': 'Virginia2',
                'zip_code': '20101',
                'roles': ['Commissioning editor2']}
    response = client.post(f'api/accounts/', json=account)
    assert response.status_code < 400
    assert 'uuid' in response.json()
    uuid = response.json()['uuid']

    response = client.post(f'api/accounts/', json=account2)
    assert response.status_code == 400

    del_resp = client.delete(f'api/accounts/{uuid}')
    assert del_resp.status_code < 400
