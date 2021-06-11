import pytest
from unittest.mock import patch

from fastapi.testclient import TestClient

from api.api import app
from settings import Session

from schemas import NestedInitiativeSchema, InitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema
from models import Account, AccountSettings, NestedInitiative, PersonalIdentifier, Initiative

from tests.fake_data_utils import generate_fake_initiatives_list, run_delete
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

    # running query.delete() does not do cascaded deletes
    run_delete(Account, db)
    run_delete(PersonalIdentifier, db)
    run_delete(AccountSettings, db)
    run_delete(NestedInitiative, db)
    run_delete(Initiative, db)


client = TestClient(app)

valid_account = {'username': 'DakotaMcclain',
                 'first_name': 'Jeff',
                 'last_name': 'Long',
                 'profile_pic': 'http://www.davis-burke.com/',
                 'city': 'Lake Robertburgh',
                 'state': 'Virginia',
                 'zip_code': '20101',
                 'primary_identifier_type': 'email',
                 'roles': ['Sales professional,IT',
                           'Commissioning editor']}
valid_email_identifier = {'identifier':'rebecca03@thomasrivera.com',
                          'type': 'email'}
valid_password = '^7^Cg&kt*X'
valid_account_creation_request = {'account': valid_account,
                                  'identifier': valid_email_identifier,
                                  'password': valid_password}

def test_create_account(db):
    response = client.post(f'api/accounts/', json=valid_account_creation_request)
    assert response.status_code < 400, response.json()

    response_account = response.json()
    assert 'uuid' in response_account
    uuid = response_account['uuid']

    resp = client.get(f'api/accounts/{uuid}')
    response_account = resp.json()

    identifier = db.query(PersonalIdentifier).filter_by(account_uuid=uuid).first()
    assert not identifier.verified

    del_resp = client.delete(f'api/accounts/{uuid}')
    assert del_resp.status_code < 400

    assert 'password' not in response_account
    expected_account = valid_account.copy()
    expected_account['email'] = valid_email_identifier['identifier']
    del response_account['uuid']

    assert response_account == expected_account


def test_create_duplicate_email_account(db):
    account = {'email': 'rebecca03@thomasrivera.com',
               'username': 'DakotaMcclain',
               'first_name': 'Jeff',
               'last_name': 'Long',
               'password': '^7^Cg&kt*X',
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
                'profile_pic': 'http://www.davis-burke.com/2',
                'city': 'Lake Robertburgh2',
                'state': 'Virginia2',
                'zip_code': '20101',
                'roles': ['Commissioning editor2']}
    request = {'account': account,
               'identifier': valid_email_identifier,
               'password': valid_password}

    response = client.post('api/accounts/', json=request)
    assert response.status_code < 400, response.json()
    assert 'uuid' in response.json()
    uuid = response.json()['uuid']

    request['account'] = account2
    response = client.post('api/accounts/', json=request)
    assert response.status_code == 400

    del_resp = client.delete(f'api/accounts/{uuid}')
    assert del_resp.status_code < 400


def test_account_creation_and_deletion(db):
    initiatives = generate_fake_initiatives_list(db)
    db.commit()

    response = client.post(f'api/accounts/', json=valid_account_creation_request)
    assert response.status_code < 400, response.json()

    response_account = response.json()
    uuid = response_account['uuid']

    resp = client.get(f'api/accounts/{uuid}')
    assert response.status_code < 400
    resp = resp.json()
    assert resp['email'] == valid_email_identifier['identifier']
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
    response = client.post(f'api/accounts/', json=valid_account_creation_request)
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
    response = client.post(f'api/accounts/', json=valid_account_creation_request)
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

    response = client.post(f'api/accounts/', json=valid_account_creation_request)
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
    mock_send.return_value = MockResponse(False)
    resp = client.post(f'api/notifications/',
                       {"username": "no_user_exists", "notification_type": "password_reset"})
    mock_send.assert_not_called
    assert mock_send.call_args is None

    response = client.post(f'api/accounts/', json=valid_account_creation_request).json()
    uuid = response['uuid']

    # notification for valid username
    mock_send.return_value = MockResponse(True)
    resp = client.post(f'api/notifications/',
                       json={"username": "DakotaMcclain", "notification_type": "password_reset"})
    mock_send.assert_called
    assert mock_send.call_args is not None
    # can't verify Arg contents :(

    # notification for email
    mock_send.return_value = MockResponse(True)
    resp = client.post(f'api/notifications/',
                       json={"email": "rebecca03@thomasrivera.com", "notification_type": "password_reset"})
    mock_send.assert_called
    assert mock_send.call_args is not None

    settings = db.query(AccountSettings).filter_by(uuid=uuid).first()
    assert settings.password_reset_hash is not None
    client.delete(f'api/accounts/{uuid}')


def test_account_password_reset_hash_stored(db):
    account = valid_account.copy()
    request = valid_account_creation_request.copy()
    request['account'] = account

    response = client.post(f'api/accounts/', json=request).json()
    uuid = response['uuid']

    # notification for valid username
    resp = client.post(f'api/notifications/',
                       json={"username": "DakotaMcclain", "notification_type": "password_reset"})

    resp = client.get(f'api/account_settings/{uuid}')
    settings = resp.json()

    settings = db.query(AccountSettings).filter_by(uuid=uuid).first()
    assert settings.password_reset_hash is not None
    assert settings.password_reset_time is not None
    client.delete(f'api/accounts/{uuid}')


def test_reset_account_password_with_hash(db):
    # Create an account, set a reset hash, create a new client without tokens, get new tokens from
    # the reset hash link, update password, check old password does not work and new does with
    # the basic auth api.
    account = valid_account.copy()
    request = valid_account_creation_request.copy()
    request['account'] = account
    response = client.post(f'api/accounts/', json=request).json()
    uuid = response['uuid']

    verify_account_with_uuid(db, uuid)

    # notification for valid username
    resp = client.post(f'api/notifications/',
                       json={"username": "DakotaMcclain", "notification_type": "password_reset"})

    settings = client.get(f'api/account_settings/{uuid}').json()
    # Can't get hash from email
    settings = db.query(AccountSettings).filter_by(uuid=uuid).first()
    reset_hash = settings.password_reset_hash

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
    assert resp.status_code < 400, resp.json()

    resp = client.delete(f'api/accounts/{uuid}')
    assert resp.status_code < 400

# Testing helper only
def verify_account_with_uuid(db, uuid):
    account_obj = db.query(Account).filter_by(uuid=uuid).first()
    identifiers = account_obj.personal_identifiers
    for identifier in identifiers:
        resp = client.post(f'api/verify_identifier/start',
                           json={"account_uuid": uuid,
                                 "identifier": identifier.value,
                                 "type": identifier.type.value})
        assert resp.status_code == 200, resp.json()

        token = identifier.verification_token

        resp = client.get(
            f'api/verify_identifier/finish?token={str(token.uuid)}&otp={token.otp}')
        assert resp.status_code == 200, resp.json()

def test_verify_account_with_token(db):
    account = valid_account.copy()
    request = valid_account_creation_request.copy()
    request['account'] = account

    response = client.post(f'api/accounts/', json=request).json()
    uuid = response['uuid']

    # notification for verifying registration
    # Verification has been moved from api/notifications to api/verify_identifier/start in the auth package.
    resp = client.post(f'api/verify_identifier/start',
                       json={"account_uuid": uuid,
                             "identifier": "rebecca03@thomasrivera.com",
                             "type": "email"})
    assert resp.status_code == 200

    account_obj = db.query(Account).filter_by(uuid=uuid).first()
    assert len(account_obj.personal_identifiers) == 1
    identifier = account_obj.personal_identifiers[0]
    assert identifier.verified is False
    assert identifier.verification_token is not None

    # Can't get token from email
    token = identifier.verification_token

    resp = client.get(
        f'api/verify_identifier/finish?token={str(token.uuid)}&otp={token.otp}')

    # account w/ settings
    assert resp.status_code == 200
    resp_json = resp.json()['account']
    assert str(resp_json['uuid']) == uuid
    assert resp_json['settings'] is not None

    # get updated account
    # different session used by client and test
    db.flush()
    db.commit()
    account_obj = db.query(Account).filter_by(uuid=uuid).first()
    identifier = account_obj.personal_identifiers[0]
    assert identifier.verification_token.already_used ==True
    assert identifier.verified is True


    # Cleanup account
    resp = client.delete(f'api/accounts/{uuid}')
    assert resp.status_code < 400
