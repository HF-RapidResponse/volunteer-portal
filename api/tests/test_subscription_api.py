import pytest
import logging
from unittest.mock import patch

from fastapi.testclient import TestClient

from api.api import app
from settings import Session

from tests.fake_data_utils import generate_fake_initiative, run_delete, generate_fake_account, generate_identifier, generate_email_identifier

from models import Account, AccountSettings, Subscription, PersonalIdentifier, Initiative, EmailIdentifier, SubscriptionEntity

from tests.test_notifications import MockResponse
from tests.test_account_api import create_test_account

@pytest.fixture
def client():
  return TestClient(app)

@pytest.fixture
def db():
    return Session()

# Will run each test in the `yield` portion

@pytest.fixture
def initiative(db):
  return create_initiative(db)

def create_initiative(db):
  initiative = generate_fake_initiative(db)
  db.add(initiative)
  db.commit()
  db.refresh(initiative)
  return initiative


@pytest.fixture(autouse=True)
def setup(db):
    yield  # this is where the testing happens
    db.rollback()

    # running query.delete() does not do cascaded deletes
    run_delete(Account, db)
    run_delete(Subscription, db)
    run_delete(PersonalIdentifier, db)
    run_delete(Initiative, db)

@patch('notifications_manager.email_client.send')
def test_create_accountless_subscription(mock_send, db, initiative, client):

  request = { 'entity_type': 'initiative',
              'entity_uuid': str(initiative.uuid),
              'identifier': {'identifier': 'test@gmail.com',
                             'type': 'email'}}

  mock_send.return_value = MockResponse(True)
  response = client.post(f'api/subscriptions/subscribe',
                         json=request)
  db.flush()
  db.commit()
  assert response.status_code < 400
  assert mock_send.call_args is not None

  sub = db.query(Subscription).first()
  assert sub is not None
  assert sub.entity_uuid == initiative.uuid
  assert sub.entity_type.value ==  'initiative'
  assert sub.account == None
  assert sub.identifier is not None
  assert sub.identifier.value == 'test@gmail.com'
  assert not sub.verified

  response = client.post(f'api/subscriptions/subscribe',
                         json=request)

  token = sub.verification_token

  resp = client.get(
        f'api/verify_token/finish?token={str(token.uuid)}&otp={token.otp}')
  assert resp.status_code == 200, resp.json()
  assert 'have been verified' in resp.json()['msg']



@patch('notifications_manager.email_client.send')
def test_create_subscription_with_account(mock_send, caplog, db, initiative, client):
  account = create_test_account(mock_send, db, client)

  request = { 'entity_type': 'initiative',
              'entity_uuid': str(initiative.uuid),
              'identifier': {'identifier': 'test@gmail.com',
                             'type': 'email'}}

  mock_send.return_value = MockResponse(True)
  response = client.post(f'api/subscriptions/subscribe',
                         json=request)
  assert 'Ignoring identifier in subscription' in caplog.text
  db.flush()
  db.commit()
  assert response.status_code < 400
  assert mock_send.call_args is None

  sub = db.query(Subscription).first()
  assert sub is not None
  assert sub.entity_uuid == initiative.uuid
  assert sub.entity_type.value ==  'initiative'
  assert str(sub.account.uuid) == account['uuid']
  assert sub.identifier is not None
  assert sub.identifier.value == account['email']
  assert sub.verified

@patch('notifications_manager.email_client.send')
def test_delete_subscription_with_account(mock_send, db, initiative, client):
  account = create_test_account(mock_send, db, client)
  request = { 'entity_type': 'initiative',
              'entity_uuid': str(initiative.uuid)}
  response = client.post(f'api/subscriptions/subscribe', json=request)

  uuid = response.json()['uuid']
  response = client.delete(f'api/subscriptions/{uuid}', json={})

  assert response.status_code < 400, response.json()
  assert db.query(Subscription).filter_by(uuid=uuid).count() == 0
  account = db.query(Account).filter_by(uuid=account['uuid']).first()
  assert account is not None
  assert account.primary_email_identifier is not None

def test_delete_subscription_without_account(db, initiative, client):
  id = {'identifier': 'test2@gmail.com',
        'type': 'email'}
  request = { 'entity_type': 'initiative',
              'entity_uuid': str(initiative.uuid),
              'identifier': id}

  response = client.post(f'api/subscriptions/subscribe', json=request)
  assert response.status_code < 400

  uuid = response.json()['uuid']
  response = client.delete(f'api/subscriptions/{uuid}', json={'identifier': id})

  assert response.status_code < 400, response.json()
  assert db.query(Subscription).filter_by(uuid=uuid).count() == 0
  assert db.query(PersonalIdentifier).filter_by(value='test2@gmail.com').count() == 1

def test_subscription_id_account(db, initiative, client):
  account = generate_fake_account()
  identifier = generate_email_identifier()
  account.primary_email_identifier = identifier
  db.add(account)
  db.add(identifier)

  db.flush()
  sub = Subscription(entity_type=SubscriptionEntity('initiative'),
                     entity_uuid=initiative.uuid)

  sub.account=account
  db.add(sub)
  db.commit()
  db.refresh(sub)
  assert sub.account == account
  assert sub.identifier == identifier
  assert sub.account_uuid == account.uuid

  sub2 = Subscription(entity_type=SubscriptionEntity('initiative'),
                      entity_uuid=initiative.uuid)
  db.add(sub2)
  db.commit()
  db.refresh(sub2)
  sub2.identifier = identifier

  assert sub2.account == account
  assert sub2.identifier == identifier
  assert sub2.account_uuid == account.uuid

@patch('notifications_manager.email_client.send')
def test_list_initiative_subscriptions_for_account(mock_send, db, client):
  account = create_test_account(mock_send, db, client)

  initiative1 = create_initiative(db)
  initiative2 = create_initiative(db)
  initiative3 = create_initiative(db)

  request = { 'entity_type': 'initiative',
              'entity_uuid': str(initiative1.uuid)}
  response = client.post(f'api/subscriptions/subscribe', json=request)
  assert response.status_code < 400

  request = { 'entity_type': 'initiative',
              'entity_uuid': str(initiative2.uuid)}
  response = client.post(f'api/subscriptions/subscribe', json=request)
  assert response.status_code < 400

  response = client.get(f'api/subscriptions/account/{account["uuid"]}/initiatives')
  assert response.status_code < 400
  initiatives = response.json()
  assert len(initiatives) == 2
  assert 'initiative_name' in initiatives[0]

  response = client.get(f'api/subscriptions/account/{account["uuid"]}/initiatives?uuids_only=true')
  assert response.status_code < 400
  initiative_uuids = response.json()
  assert len(initiatives) == 2
  assert str(initiative1.uuid) in initiative_uuids
  assert str(initiative2.uuid) in initiative_uuids
  assert str(initiative3.uuid) not in initiative_uuids

  response = client.get(f'api/subscriptions/account/{account["uuid"]}/initiative_map')
  assert response.status_code < 400
  initiative_map = response.json()
  assert initiative1.initiative_name in initiative_map
  assert initiative_map[initiative1.initiative_name] == True
  assert initiative2.initiative_name in initiative_map
  assert initiative_map[initiative2.initiative_name] == True
  assert initiative3.initiative_name in initiative_map
  assert initiative_map[initiative3.initiative_name] == False

@patch('notifications_manager.email_client.send')
def test_create_duplicate_subscriptions(mock_send, db, initiative, client):

  request = { 'entity_type': 'initiative',
              'entity_uuid': str(initiative.uuid),
              'identifier': {'identifier': 'test@gmail.com',
                             'type': 'email'}}

  mock_send.return_value = MockResponse(True)
  response = client.post(f'api/subscriptions/subscribe', json=request)
  response = client.post(f'api/subscriptions/subscribe', json=request)
  response = client.post(f'api/subscriptions/subscribe', json=request)
  response = client.post(f'api/subscriptions/subscribe', json=request)
  db.flush()
  db.commit()

  # should not indicate that subscriptions exists already - dont want to leak others' info
  assert response.status_code < 400

  assert db.query(Subscription).count() == 1
