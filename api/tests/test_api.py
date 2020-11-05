import pytest
from typing import List
from uuid import UUID
from datetime import datetime

from fastapi.testclient import TestClient
from pydantic import error_wrappers

from api import app
from models import Initiative, VolunteerEvent, VolunteerRole

client = TestClient(app)

def test_create_model():
    good_event_kwargs = {
        "event_uuid": "3457f844-5a3a-4efe-b16d-443c24961c68",
        "event_external_id": "Medical too same money gas director rule.",
        "name": "Medical too same money gas director rule.",
        "details_url": "https://time.ca/interest/people.html",
        "hero_image_url": "https://hill.com/category/about.html",
        "start_datetime": "2020-10-25T15:19:51.824283",
        "end_datetime": "2020-11-02T15:19:51.824283",
        "description": "Early sign page pretty heart bring share. Television research agency minute fine Mr together. Each treat strategy director. Detail million guess someone base for upon.",
        "point_of_contact": None,
        "signup_url": "https://moreno.com/post.htm"
    }

    good_event = VolunteerEvent(**good_event_kwargs)

    assert good_event
    assert type(good_event) is VolunteerEvent
    assert type(good_event.event_uuid) is UUID
    assert type(good_event.end_datetime) is datetime

def test_create_model_error():
    with pytest.raises(error_wrappers.ValidationError):
        bad_event_kwargs = {
            "event_uuid": 1234,
            "event_external_id": "Medical too same money gas director rule.",
            "hero_image_url": "https://hill.com/category/about.html",
            "start_datetime": "2020-10-25T15:19:51.824283",
            "description": "Early sign page pretty heart bring share. Television research agency minute fine Mr together. Each treat strategy director. Detail million guess someone base for upon.",
            "point_of_contact": None,
            "sign_up_link": "https://moreno.com/post.htm"
        }

        _ = VolunteerEvent(**bad_event_kwargs)

def test_get_initiatives_api():
    # because Initiatives contain VolunteerEvents and VolunteerRoles, this will test field validations on all three models
    response = client.get('api/initiatives')
    assert response.status_code == 200

    initiatives = [Initiative(**initiative_kwargs) for initiative_kwargs in response.json()]

    assert type(initiatives[-1]) is Initiative