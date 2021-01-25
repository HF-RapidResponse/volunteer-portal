import pytest
from datetime import datetime
from faker import Faker
from random import seed
from models import DonationEmail
from settings import Session
from uuid import UUID

fake = Faker()
seed(1000)


@pytest.fixture
def db():
    return Session()


# Will run each test in the `yield` portion
@pytest.fixture(autouse=True)
def setup(db):
    db = Session()
    yield # this is where the testing happens
    db.rollback()

def test_donation_email_insert(db):
    donation = DonationEmail(email = fake.email())
    inserted_donation = db.add(donation)

    lookup = db.query(DonationEmail).filter_by(email=donation.email).scalar()


    # Validate types
    assert type(lookup.donation_uuid) is UUID
    assert lookup.email == donation.email
    assert type(lookup.request_sent) is datetime
    assert lookup.request_sent == donation.request_sent
