from time import sleep
import pytest
from unittest.mock import patch
from settings import Session

from pydantic import EmailError
from fastapi.testclient import TestClient
from sqlalchemy import and_
from phonenumbers.phonenumberutil import NumberParseException
from fastapi_jwt_auth import AuthJWT

from models import Account, PersonalIdentifier, StandardEmailIdentifier, PhoneNumberIdentifier, IdentifierType, VerificationToken, AccountSettings
from api.api import app
import auth
from tests.test_account_api import valid_account_creation_request
from tests.fake_data_utils import run_delete
from identifiers_helper import get_or_create_identifier

@pytest.fixture(autouse=True)
def setup(db):
    yield  # this is where the testing happens
    db.rollback()
    run_delete(Account, db)
    run_delete(PersonalIdentifier, db)
    run_delete(VerificationToken, db)

@pytest.fixture(scope='function')
def client():
    return TestClient(app)

@pytest.fixture
def db():
    return Session()

def test_personal_identifiers_relationships_and_polymorphism(db):
    account = Account(first_name='Test', last_name='Success')

    account_email = StandardEmailIdentifier(value='good.email@example.com')
    account.primary_email_identifier = account_email

    other_email = StandardEmailIdentifier(value='another.good.email@example.com')

    account_phone_number = PhoneNumberIdentifier(value='+1 1-800-444-4444')
    account.primary_phone_number_identifier = account_phone_number
    other_phone_number = PhoneNumberIdentifier(value='+1 805 334 8626')

    db.add(other_email)
    db.add(other_phone_number)
    db.add(account)
    db.commit()

    assert account.personal_identifiers

    assert other_email.account is None
    assert other_phone_number.account is None

    other_email.account_uuid = account.uuid

    linked_email = account.primary_email_identifier
    linked_phone_number = account.primary_phone_number_identifier
    assert linked_email.uuid == account_email.uuid
    assert linked_email.account_uuid == account.uuid
    assert linked_email in account.personal_identifiers
    assert linked_phone_number.uuid == account_phone_number.uuid
    assert linked_phone_number in account.personal_identifiers

    email_linked_account = account_email.account
    phone_number_linked_account = account_phone_number.account
    assert email_linked_account.uuid == account.uuid
    assert phone_number_linked_account.uuid == account.uuid

    queried_email = db.query(PersonalIdentifier).filter(and_(PersonalIdentifier.account==account, PersonalIdentifier.type==IdentifierType.EMAIL)).first()
    queried_phone_number = db.query(PersonalIdentifier).filter(and_(PersonalIdentifier.account==account, PersonalIdentifier.type==IdentifierType.PHONE)).first()
    assert queried_email.uuid == account_email.uuid
    assert queried_phone_number.uuid == account_phone_number.uuid


def test_email_validation():
    good_email = StandardEmailIdentifier(value='good.email@example.com')
    assert good_email.value == 'good.email@example.com'

    with pytest.raises(EmailError):
        _ = StandardEmailIdentifier(value='@not.a good email')

    with pytest.raises(AssertionError):
        account = Account(first_name=' Test', last_name='Success')
        good_phone_number = PhoneNumberIdentifier(value='+1 1-800-444-4444')
        account.primary_email_identifier = good_phone_number

def test_phone_number_validation():
    good_phone_number = PhoneNumberIdentifier(value='+1 1-800-444-4444')
    assert good_phone_number.value == '+18004444444'

    with pytest.raises(NumberParseException):
        _ = PhoneNumberIdentifier(value='987325')

    with pytest.raises(AssertionError):
        account = Account(first_name=' Test', last_name='Success')
        good_email = StandardEmailIdentifier(value='good.email@example.com')
        account.primary_phone_number_identifier = good_email

@patch('auth.notifications_manager.send_notification')
def test_verify_personal_identifier_without_account(mock_send, db, client):
    begin_response = client.post(
        'api/verify_identifier/start',
        json = {'identifier': 'email_to_verify@example.com', 'type': 'email'}
    )

    assert begin_response.status_code == 200, begin_response.json()
    assert begin_response.json()['verification_token_uuid']
    assert mock_send.called

    token = db.query(VerificationToken).filter(and_(PersonalIdentifier.type==IdentifierType.EMAIL, PersonalIdentifier.value=='email_to_verify@example.com')).order_by(VerificationToken.created_at.desc()).first()

    finish_response = client.get(
        f'api/verify_token/finish?token={str(token.uuid)}&otp={token.otp}')

    assert finish_response.status_code == 200
    expected = {'msg': 'The provided token\'s associated values have been verified',
                'account': None}
    assert finish_response.json() == expected


@patch('auth.notifications_manager.send_notification')
def test_verify_personal_identifier_with_account(mock_send, db, client):
    account = client.post(f'api/accounts/', json=valid_account_creation_request).json()
    settings = client.get(f'api/account_settings/{account["uuid"]}').json()

    account['settings'] = settings
    # this will be a logged out notification - cant get tokens until after verification.
    begin_response = client.post(
        'api/verify_identifier/start',
            json = {'identifier': 'another_email_to_verify@example.com', 'type': 'email'}
    )

    assert begin_response.status_code == 200
    assert begin_response.json()['verification_token_uuid']
    assert mock_send.called

    token = db.query(VerificationToken).filter(and_(PersonalIdentifier.type==IdentifierType.EMAIL, PersonalIdentifier.value=='another_email_to_verify@example.com')).order_by(VerificationToken.created_at.desc()).first()
    assert str(token.personal_identifier.account.uuid) == account['uuid']

    finish_response = client.get(
        f'api/verify_token/finish?token={str(token.uuid)}&otp={token.otp}')

    assert finish_response.status_code == 200, finish_response.json()
    expected = {'msg': None, 'account': account}
    assert finish_response.json() == expected

def test_duplicate_identifier_values_with_different_types(db):
    state1, identifier1 =  get_or_create_identifier(IdentifierType.EMAIL, 'test@gmail.com', db)
    state2, identifier2 =  get_or_create_identifier(IdentifierType.GOOGLE_ID, 'test@gmail.com', db)
