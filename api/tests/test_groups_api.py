import pytest

from fastapi.testclient import TestClient
from api.api import app

from settings import Session

from models import Account, AccountSettings, Group, UserGroupRelation

from tests.fake_data_utils import (generate_fake_group, create_fake_account, generate_fake_groups_list,
                                   generate_fake_users_groups_and_relations)

@pytest.fixture
def db():
    return Session()

# Will run each test in the `yield` portion


@pytest.fixture(autouse=True)
def setup(db):
    db = Session()
    yield  # this is where the testing happens
    db.rollback()
    db.query(UserGroupRelation).delete()
    db.query(Account).delete()
    db.query(AccountSettings).delete()
    db.query(Group).delete()
    db.commit()


client = TestClient(app)

def test_get_all_groups(db):
  group = generate_fake_group()
  db.add(group)
  db.commit()

  resp = client.get(f'api/groups/')
  assert resp.status_code == 200

  print(resp.json())

  print("AAAAAAAA", create_fake_account(client))

  resp = client.get(f'api/groups/{group.uuid}')
  print("CCCCCCCCC", resp.json())


def test_get_all_groups2(db):
    generate_fake_users_groups_and_relations(db, client, user_count=100, group_count=30)
    db.commit()
    account = db.query(Account).first()
    res2 = db.query(Group, UserGroupRelation).join(UserGroupRelation)\
                                             .filter(UserGroupRelation.user_id==account.uuid).all()

    print(res2)
    resp = client.get(f'api/groups/user/{account.uuid}')
    print("CCCCCCCCCCCC", resp.json())

    resp = client.post(f'api/auth/basic', json={"email": account.email, "password": "test.1234"})
    print("AAAAAAAAAAAAUTH2", resp.json())
    resp = client.get(f'api/groups/user/{account.uuid}')
    print("CCCCCCCCCCCC2", resp.json())

    resp = client.get(f'api/groups/user/{account.uuid}?relationship_type=MEMBER')
    resp = client.get(f'api/groups/user/{account.uuid}?relationship_type=ADMIN')
    print("CCCCCCCCCCCC2", resp.json())

def test_get_group_admin(db):
    generate_fake_users_groups_and_relations(db, client, user_count=20, group_count=6)
    db.commit()

    group = db.query(Group).first()
    resp = client.get(f'api/groups/{group.uuid}/admin')
    print(resp.json())

def test_stats(db):
    generate_fake_users_groups_and_relations(db, client, user_count=20, group_count=6)
    db.commit()

    group = db.query(Group).first()

    resp = client.get(f'api/groups/{group.uuid}/stats')
    print("DDDDDDDDD", resp.json())


def test_distance(db):
    groups = generate_fake_groups_list(db, 30)
    db.commit()

    zipcode = 40204

    resp = client.get(f'api/groups/close_to_zip/{zipcode}')

    assert resp.status_code < 400
