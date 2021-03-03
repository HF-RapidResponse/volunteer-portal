from time import sleep
import pytest
from unittest.mock import patch
from settings import Session

from fastapi.testclient import TestClient
from sqlalchemy import and_
from email_validator import EmailNotValidError, validate_email
from phonenumbers.phonenumberutil import NumberParseException
from fastapi_jwt_auth import AuthJWT

from models import Account, PersonalIdentifier, EmailIdentifier, PhoneNumberIdentifier, IdentifierType, VerificationToken
from api.api import app
import auth

@pytest.fixture(scope='function')
def client():
    return TestClient(app)

@pytest.fixture
def db():
    return Session()

def test_personal_identifiers_relationships_and_polymorphism(db):
    account = Account(first_name='Test', last_name='Success')

    account_email = EmailIdentifier(value='good.email@example.com')
    account.primary_email_identifier = account_email
    other_email = EmailIdentifier(value='another.good.email@example.com')

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

    linked_email = account.primary_email_identifier
    linked_phone_number = account.primary_phone_number_identifier
    assert linked_email.uuid == account_email.uuid
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

    [db.delete(record) for record in [account, other_email, other_phone_number]]
    db.commit()

def test_email_validation():
    good_email = EmailIdentifier(value='good.email@example.com')
    assert good_email.value == 'good.email@example.com'

    with pytest.raises(EmailNotValidError):
        _ = EmailIdentifier(value='@not.a good email')

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
        good_email = EmailIdentifier(value='good.email@example.com')
        account.primary_phone_number_identifier = good_email

@patch('auth.notifications_manager.send_notification')
def test_verify_personal_identifier_without_account(mock_send, db, client):
    begin_response = client.post(
        'api/verify_identifier/start',
        json = {'identifier': 'email_to_verify@example.com', 'type': 'email'}
    )

    assert begin_response.status_code == 200
    assert begin_response.json()['verification_token_uuid']
    assert mock_send.called

    token = db.query(VerificationToken).filter(and_(PersonalIdentifier.type==IdentifierType.EMAIL, PersonalIdentifier.value=='email_to_verify@example.com')).order_by(VerificationToken.created_at.desc()).first()

    finish_response = client.post(
        'api/verify_identifier/finish',
        json = {'verification_token_uuid': str(token.uuid), 'otp': token.otp}
    )

    assert finish_response.status_code == 200
    assert finish_response.json() == {'msg': 'The provided token\'s personal identifier has been verified'}

    db.delete(token)
    db.commit()

# Can't figure out how to mock an authenticated session
# Not sure what magic fastapi_jwt_auth is doing here: 
# https://github.com/IndominusByte/fastapi-jwt-auth/blob/master/tests/test_url_protected.py

# @patch('auth.notifications_manager.send_notification')
# def test_verify_personal_identifier_with_account(mock_send, db, client, Authorize):
#     account = Account(first_name='Verification', last_name='Test')
#     db.add(account)
#     db.commit()
#     jwt = Authorize.create_access_token(subject=str(account.uuid))

#     begin_response = client.post(
#         'api/verify_identifier/start',
#         headers = {"Authorization":f"Bearer {jwt}"},
#         json = {'identifier': 'another_email_to_verify@example.com', 'type': 'email'}
#     )

#     assert begin_response.status_code == 200
#     assert begin_response.json()['verification_token_uuid']
#     assert mock_send.called

#     token = db.query(VerificationToken).filter(and_(PersonalIdentifier.type==IdentifierType.EMAIL, PersonalIdentifier.value=='another_email_to_verify@example.com')).order_by(VerificationToken.created_at.desc()).first()
#     assert token.personal_identifier.account.uuid == account.uuid

#     finish_response = client.post(
#         'api/verify_identifier/finish',
#         headers = {"Authorization":f"Bearer {jwt}"},
#         json = {'verification_token_uuid': str(token.uuid), 'otp': token.otp}
#     )

#     assert finish_response.status_code == 200
#     assert finish_response.json() == {'msg': 'The provided token\'s personal identifier has been verified'}

#     db.delete(account)
#     db.delete(token)
#     db.commit()
