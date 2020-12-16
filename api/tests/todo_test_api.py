import pytest
from uuid import UUID, uuid4
from datetime import datetime, timedelta

from fastapi.testclient import TestClient
from pydantic import error_wrappers

from api import app
from models import Initiative, VolunteerEvent, PersonalDonationLinkRequest
from schemas import PersonalDonationLinkRequestSchema, InitiativeSchema, VolunteerEventSchema, NestedInitiativeSchema
from settings import Session
from tests.fake_data_utils import generate_fake_initiatives_list

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

def test_create_model():
    good_event_kwargs = {
        "event_uuid": uuid4(),
        "event_external_id": "Medical too same money gas director rule.",
        "name": "Medical too same money gas director rule.",
        "details_url": "https://time.ca/interest/people.html",
        "hero_image_urls": [{"url":"https://hill.com/category/about.html"}],
        "start_datetime": datetime.now(),
        "end_datetime": datetime.now() + timedelta(days=1),
        "description": "Early sign page pretty heart bring share. Television research agency minute fine Mr together. Each treat strategy director. Detail million guess someone base for upon.",
        "point_of_contact_name": None,
        "signup_url": "https://moreno.com/post.htm"
    }

#    good_event_schema = VolunteerEventSchema(**good_event_kwargs)
    good_event = VolunteerEvent(**good_event_kwargs)

    assert good_event
    assert type(good_event) is VolunteerEvent
    assert type(good_event.event_uuid) is UUID
    assert type(good_event.end_datetime) is datetime

# check that pydantic does type checking - details_url is the malformed field.
def test_create_model_error():
    with pytest.raises(error_wrappers.ValidationError):
        bad_event_kwargs = {
            "event_uuid": uuid4(),
            "event_external_id": "Medical too same money gas director rule.",
            "name": "Medical too same money gas director rule.",

            "details_url": "not a url",
            "hero_image_urls": [{"url":"https://hill.com/category/about.html"}],
            "start_datetime": datetime.now(),
            "end_datetime": datetime.now() + timedelta(days=1),
            "description": "Early sign page pretty heart bring share. Television research agency minute fine Mr together. Each treat strategy director. Detail million guess someone base for upon.",
            "point_of_contact_name": None,
            "signup_url": "https://moreno.com/post.htm"
        }

        model = VolunteerEvent(**bad_event_kwargs)
        schema = VolunteerEventSchema(**model.__dict__)

def test_get_initiatives_api(db):
    initiative_list = generate_fake_initiatives_list(db, count=2, roles_count=2, events_count=1)
    db.commit()

    # because Initiatives contain VolunteerEvents and VolunteerRoles, this will test field validations on all three models
    response = client.get('api/initiatives')
    assert response.status_code == 200
    initiatives = [NestedInitiativeSchema(**initiative_kwargs) for initiative_kwargs in response.json()]

    expected_initiative = initiative_list[0]
    result_initiative = None
    for i in initiatives:
        if expected_initiative.initiative_uuid == i.initiative_uuid:
            result_initiative = i
            break

    assert result_initiative is not None, "no matching initiative found"
    assert result_initiative.name == expected_initiative.name
    assert len(result_initiative.events) == len(expected_initiative.events)

def test_create_link_request_error():
    with pytest.raises(error_wrappers.ValidationError):
        bad_link_request_kwargs = {
            "email": "name@gmail"
        }
        PersonalDonationLinkRequestSchema(**bad_link_request_kwargs)

def test_create_link_request():
    good_link_request_kwargs = {
        "email": "name@gmail.com"
    }
    good_request = PersonalDonationLinkRequestSchema(**good_link_request_kwargs)
    assert good_request
    assert type(good_request) is PersonalDonationLinkRequestSchema
    assert type(good_request.request_sent) is datetime

def test_post_link_request(db):
    requests_in_db_pre = len(db.query(PersonalDonationLinkRequest).all())
    good_link_request_kwargs = {
        "email": "name@gmail.com"
    }
    resp = client.post('api/donation_link_requests/', json=good_link_request_kwargs)

    assert resp.status_code == 200

    requests_in_db_post = len(db.query(PersonalDonationLinkRequest).all())
    assert requests_in_db_post - requests_in_db_pre == 1
