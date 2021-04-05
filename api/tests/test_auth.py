import pytest

from fastapi.testclient import TestClient

from api.api import app
from settings import Session

from schemas import NestedInitiativeSchema, InitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema
from models import NestedInitiative, Initiative, VolunteerRole, VolunteerEvent

from tests.fake_data_utils import generate_fake_initiative, generate_fake_volunteer_role
from tests.fake_data_utils import generate_fake_volunteer_event
from tests.fake_data_utils import generate_fake_initiatives_list

from auth import create_access_and_refresh_tokens, create_token_for_user

@pytest.fixture
def db():
    return Session()

# Will run each test in the `yield` portion


@pytest.fixture(autouse=True)
def setup(db):
    yield  # this is where the testing happens
    db.rollback()


client = TestClient(app)

def test_get_token_from_email():
  pass

def test_user_token():
  return
  create_token_for_user(Authorize, "testid")
