from time import sleep
import pytest
from unittest.mock import patch
from settings import Session

from models import Account, PersonalIdentifier, EmailIdentifier, PhoneNumberIdentifier

@pytest.fixture
def db():
    return Session()

def test_personal_identifiers_polymorphism(db):
    account = Account(first_name='Test', last_name='Success')

    account_email = EmailIdentifier(value='good.email@example.com')
    account.email_identifier = account_email
    other_email = EmailIdentifier(value='another.good.email@example.com')

    account_phone_number = PhoneNumberIdentifier(value='+1 1-800-444-4444')
    account.phone_number_identifier = account_phone_number
    other_phone_number = PhoneNumberIdentifier(value='+1 805 334 8626')

    db.add(other_email)
    db.add(other_phone_number)
    db.add(account)
    db.commit()

    assert other_email.account is None
    assert other_phone_number.account is None

    linked_email = account.email_identifier
    linked_phone_number = account.phone_number_identifier
    assert linked_email.uuid == account_email.uuid
    assert linked_phone_number.uuid == account_phone_number.uuid

    email_linked_account = account_email.account
    phone_number_linked_account = account_phone_number.account
    assert email_linked_account.uuid == account.uuid
    assert phone_number_linked_account.uuid == account.uuid

    # db.query(PersonalIdentifier).filter(PersonalIdentifier.account==account).first

    [db.delete(record) for record in [account, other_email, other_phone_number]]
    db.commit()