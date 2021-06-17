import pytest
from unittest.mock import patch, PropertyMock
from models import VerificationToken, PhoneNumberIdentifier
from settings import Session

@pytest.fixture
def db():
    return Session()


# Will run each test in the `yield` portion
@pytest.fixture(autouse=True)
def setup(db):
    db = Session()
    yield # this is where the testing happens
    db.rollback()

def test_successfully_verify_otp(db):
    token = VerificationToken()
    identifier_to_verify = PhoneNumberIdentifier(value='+1 1-800-444-4444')
    token.personal_identifier = identifier_to_verify
    db.add(token)
    db.commit()

    otp = token.otp
    assert token.verify(otp, db)
    assert identifier_to_verify.verified

    db.delete(token)
    db.delete(identifier_to_verify)
    db.commit()

@patch.object(VerificationToken, 'is_expired', new_callable=PropertyMock)
def test_expired_otp(mock_is_expired, db):
    with pytest.raises(ValueError) as e:
        mock_is_expired.return_value = False

        token = VerificationToken()
        identifier_to_verify = PhoneNumberIdentifier(value='+1 1-800-444-4444')
        token.personal_identifier = identifier_to_verify
        db.add(token)
        db.commit()

        otp = token.otp

        mock_is_expired.return_value = True
        token.verify(otp, db)
    assert 'has expired' in e.value.args[0]
    assert not identifier_to_verify.verified

    db.delete(token)
    db.delete(identifier_to_verify)
    db.commit()

def test_already_used_otp(db):
    with pytest.raises(ValueError) as e:
        token = VerificationToken()
        identifier_to_verify = PhoneNumberIdentifier(value='+1 1-800-444-4444')
        token.personal_identifier = identifier_to_verify
        db.add(token)
        db.commit()

        otp = token.otp
        token.verify(otp, db)
        token.verify(otp, db)
    assert 'has been previously successfully verified' in e.value.args[0]
    assert identifier_to_verify.verified

    db.delete(token)
    db.delete(identifier_to_verify)
    db.commit()

def test_previous_token_verification_has_no_affect(db):
    previous_token = VerificationToken()
    identifier_to_verify = PhoneNumberIdentifier(value='+1 1-800-444-4444')
    previous_token.personal_identifier = identifier_to_verify
    db.add(previous_token)
    db.commit()

    new_token = VerificationToken()
    new_token.personal_identifier = identifier_to_verify
    db.add(new_token)
    db.commit()

    otp = previous_token.otp
    previous_token.verify(otp, db)

    assert not identifier_to_verify.verified

    otp = new_token.otp
    new_token.verify(otp, db)

    assert identifier_to_verify.verified
    db.delete(previous_token)
    db.delete(new_token)
    db.delete(identifier_to_verify)
    db.commit()
