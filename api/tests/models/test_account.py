import pytest
from datetime import datetime
from models import Initiative, VolunteerRole, VolunteerEvent
from sqlalchemy.exc import IntegrityError
from settings import Session
from sqlalchemy.orm import lazyload
from tests.fake_data_utils import generate_fake_account
from uuid import UUID
from models import Account

@pytest.fixture
def db():
    return Session()


# Will run each test in the `yield` portion
@pytest.fixture(autouse=True)
def setup(db):
    db = Session()
    yield # this is where the testing happens
    db.query(Account).delete()
    db.commit()

def test_account_create_valid(db):
    account = generate_fake_account()
    db.add(account)
    db.commit()

def test_account_create_duplicate_email(db):
    account = generate_fake_account()
    db.add(account)
    account2 = generate_fake_account()
    account2.email = account.email
    db.add(account2)

    with pytest.raises(IntegrityError):
      db.commit()


def test_account_create_duplicate_username(db):
    account = generate_fake_account()
    db.add(account)
    account2 = generate_fake_account()
    account2.username = account.username
    db.add(account2)

    with pytest.raises(IntegrityError):
      db.commit()
