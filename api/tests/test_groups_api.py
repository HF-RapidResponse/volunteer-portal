import pytest

from fastapi.testclient import TestClient
from api.api import app

from settings import Session

from tests.fake_data_utils import generate_fake_group, create_fake_account, generate_fake_user_group_relations

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

def test_get_all_groups(db):
  group = generate_fake_group()
  db.add(group)
  db.commit()

  resp = client.get(f'api/groups/')
  assert resp.status_code == 200

  print(resp.json())

  print("AAAAAAAA", create_fake_account())


def test_get_all_groups2(db):
    generate_fake_user_group_relations(db, user_count=100, group_count=30)
