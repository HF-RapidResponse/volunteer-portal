import pytest
from unittest.mock import patch

from fastapi.testclient import TestClient

from api.api import app
from settings import Session

from schemas import NestedInitiativeSchema, InitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema
from models import Account, AccountSettings, NestedInitiative

from tests.fake_data_utils import generate_fake_initiatives_list
from tests.test_api import cleanup_initiative
from tests.test_notifications import MockResponse
import notifications_manager as nm


@pytest.fixture
def db():
    return Session()

# Will run each test in the `yield` portion


@pytest.fixture(autouse=True)
def setup(db):
    yield  # this is where the testing happens
    db.rollback()


client = TestClient(app)

valid_account = {'email': 'rebecca03@thomasrivera.com',
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
                           'Commissioning editor'],
                 'is_verified': True}


def test_create_account(db):
    response = client.post(f'api/accounts/', json=valid_account)
    assert response.status_code < 400

    response_account = response.json()
    assert 'uuid' in response_account
    uuid = response_account['uuid']

    resp = client.get(f'api/accounts/{uuid}')
    response_account = resp.json()

    del_resp = client.delete(f'api/accounts/{uuid}')
    assert del_resp.status_code < 400

    assert 'password' not in response_account
    expected_account = valid_account.copy()
    del expected_account['password']
    del response_account['uuid']

    assert response_account == expected_account


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
    response = client.post('api/accounts/', json=account)
    assert response.status_code < 400
    assert 'uuid' in response.json()
    uuid = response.json()['uuid']

    response = client.post('api/accounts/', json=account2)
    assert response.status_code == 400

    del_resp = client.delete(f'api/accounts/{uuid}')
    assert del_resp.status_code < 400


def test_account_creation_and_deletion(db):
    initiatives = generate_fake_initiatives_list(db)
    db.commit()

    response = client.post(f'api/accounts/', json=valid_account)
    assert response.status_code < 400, response.json()

    response_account = response.json()
    uuid = response_account['uuid']

    resp = client.get(f'api/accounts/{uuid}')
    assert response.status_code < 400
    resp = resp.json()
    assert resp['email'] == valid_account['email']
    assert 'password' not in resp

    resp = client.get(f'api/account_settings/{uuid}')
    assert response.status_code < 400
    resp = resp.json()
    # check default settings
    assert resp['show_name'] == False
    assert resp['show_email'] == False
    assert resp['show_location'] == True
    assert resp['organizers_can_see'] == True
    assert resp['volunteers_can_see'] == True
    default_initiatives_map = {x.initiative_name: False for x in initiatives}
    assert resp['initiative_map'] == default_initiatives_map

    del_resp = client.delete(f'api/accounts/{uuid}')
    assert del_resp.status_code < 400

    [cleanup_initiative(db, i) for i in initiatives]
    settings = db.query(AccountSettings).all()
    accounts = db.query(Account).all()
    assert len(settings) == len(accounts)
    assert len(accounts) == 0


def test_bad_auth_cookie_fails_account_get(db):
    response = client.post(f'api/accounts/', json=valid_account)
    assert response.status_code < 400, response.json()

    response_account = response.json()
    uuid = response_account['uuid']

    resp = client.get(f'api/accounts/{uuid}')
    assert resp.status_code < 400

    # messs up access token
    access_token_cookie = client.cookies.get('access_token_cookie')
    bad_access_token_cookie = access_token_cookie[:-4] + "aaaa"
    client.cookies.set('access_token_cookie',
                       bad_access_token_cookie, domain='testserver.local')

    resp = client.get(f'api/accounts/{uuid}')
    assert resp.status_code == 422
    assert resp.json()['detail'] == 'Signature verification failed'

    client.cookies.set('access_token_cookie',
                       access_token_cookie, domain='testserver.local')
    del_resp = client.delete(f'api/accounts/{uuid}')
    assert del_resp.status_code < 400


def test_account_update(db):
    account = valid_account.copy()
    response = client.post(f'api/accounts/', json=account)
    response_account = response.json()
    uuid = response_account['uuid']

    account['zip_code'] = '40204'
    resp = client.put(f'/api/accounts/{uuid}', json=account)
    assert resp.status_code < 400

    resp = client.get(f'/api/accounts/{uuid}')
    assert resp.status_code < 400 and resp.json()['zip_code'] == '40204'

    del_resp = client.delete(f'api/accounts/{uuid}')
    assert del_resp.status_code < 400


def test_account_settings_update(db):
    initiatives = generate_fake_initiatives_list(db)
    db.commit()

    response = client.post(f'api/accounts/', json=valid_account)
    response_account = response.json()
    uuid = response_account['uuid']

    resp = client.get(f'api/account_settings/{uuid}')
    settings = resp.json()

    assert 'show_location' in settings
    assert 'initiative_map' in settings
    assert settings['show_location'] == True
    settings['show_location'] = False
    im = settings['initiative_map']
    for k in im.keys():
        assert im[k] == False
        im[k] = True

    resp = client.put(f'/api/account_settings/{uuid}', json=settings)
    assert resp.status_code < 400

    resp = client.get(f'api/account_settings/{uuid}')
    settings = resp.json()

    assert settings['show_location'] == False
    im = settings['initiative_map']
    for k in im.keys():
        assert im[k] == True

    del_resp = client.delete(f'api/accounts/{uuid}')
    assert del_resp.status_code < 400
    [cleanup_initiative(db, i) for i in initiatives]


@patch('notifications_manager.email_client.send')
def test_account_password_reset_notification(mock_send, db):
    # no notification for missing user
    resp = client.post(f'api/notifications/',
                       {"username": "no_user_exists", "notification_type": "password_reset"})
    mock_send.assert_not_called
    assert mock_send.call_args is None

    response = client.post(f'api/accounts/', json=valid_account).json()
    uuid = response['uuid']

    # notification for valid username
    resp = client.post(f'api/notifications/',
                       json={"username": "DakotaMcclain", "notification_type": "password_reset"})
    mock_send.assert_called
    assert mock_send.call_args is not None
    # can't verify Arg contents :(

    # notification for email username
    resp = client.post(f'api/notifications/',
                       json={"email": "rebecca03@thomasrivera.com", "notification_type": "password_reset"})
    mock_send.assert_called
    assert mock_send.call_args is not None

    resp = client.get(f'api/account_settings/{uuid}')
    assert resp.json()['password_reset_hash'] is None
    client.delete(f'api/accounts/{uuid}')


def test_account_password_reset_hash_stored(db):
    account = valid_account.copy()
    account['oauth'] = None
    response = client.post(f'api/accounts/', json=account).json()
    uuid = response['uuid']

    # notification for valid username
    resp = client.post(f'api/notifications/',
                       json={"username": "DakotaMcclain", "notification_type": "password_reset"})

    resp = client.get(f'api/account_settings/{uuid}')
    settings = resp.json()

    assert settings['password_reset_hash'] is not None
    assert settings['password_reset_time'] is not None
    client.delete(f'api/accounts/{uuid}')


def test_reset_account_password_with_hash(db):
    # Create an account, set a reset hash, create a new client without tokens, get new tokens from
    # the reset hash link, update password, check old password does not work and new does with
    # the basic auth api.
    account = valid_account.copy()
    account['oauth'] = None
    response = client.post(f'api/accounts/', json=account).json()
    uuid = response['uuid']

    # notification for valid username
    resp = client.post(f'api/notifications/',
                       json={"username": "DakotaMcclain", "notification_type": "password_reset"})

    settings = client.get(f'api/account_settings/{uuid}').json()
    print(settings)
    # Can't get hash from email
    reset_hash = settings['password_reset_hash']

    # get a new client to remove existing cookies
    new_client = TestClient(app)
    resp = new_client.get(f'api/account_settings/{uuid}')
    assert resp.status_code > 400
    resp = new_client.get(f'api/settings_from_hash')
    assert resp.status_code > 400

    resp = new_client.patch(
        f'api/accounts/{uuid}', json={'password': 'new_password.123'})
    assert resp.status_code == 401

    resp = new_client.get(f'api/settings_from_hash?pw_reset_hash={reset_hash}')
    assert resp.status_code < 400, resp.json()

    resp = new_client.patch(
        f'api/accounts/{uuid}', json={'password': 'new_password.123'})
    assert resp.status_code < 400

    new_client = TestClient(app)
    resp = new_client.post(f'api/auth/basic', json={'email': 'rebecca03@thomasrivera.com',
                                                    'password': 'wrong_password.123'})
    assert resp.status_code > 400
    resp = new_client.post(f'api/auth/basic', json={'email': 'rebecca03@thomasrivera.com',
                                                    'password': 'new_password.123'})
    assert resp.status_code < 400

    resp = client.delete(f'api/accounts/{uuid}')
    assert resp.status_code < 400


def test_verify_account_with_hash(db):
    new_account = {'email': 'rebecca03@thomasrivera.com',
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
                             'Commissioning editor'],
                   'is_verified': False}
    account = new_account.copy()
    account['oauth'] = None
    response = client.post(f'api/accounts/', json=account).json()
    uuid = response['uuid']

    # notification for verifying registration
    resp = client.post(f'api/notifications/',
                       json={"username": "DakotaMcclain", "email": "rebecca03@thomasrivera.com", "notification_type": "verify_registration"})
    assert resp.status_code == 204

    resp = client.get(f'api/account_settings/{uuid}')
    assert resp.status_code == 200

    settings = resp.json()
    reset_hash = settings['password_reset_hash']
    assert reset_hash is None
    cancel_hash = settings['cancel_registration_hash']
    assert cancel_hash is not None
    verify_hash = settings['verify_account_hash']
    assert verify_hash is not None

    resp = client.get(f'api/verify_account_from_hash?verify_hash={verify_hash}')
    resp_json = resp.json()

    assert resp.status_code == 200
    assert resp_json['verify_account_hash'] is None
    assert resp_json['cancel_registration_hash'] is not None
    assert resp_json['is_verified'] is True

    # Cleanup account
    resp = client.delete(f'api/accounts/{uuid}')
    assert resp.status_code < 400
