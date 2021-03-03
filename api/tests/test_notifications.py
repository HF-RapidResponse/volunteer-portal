import pytest
from unittest.mock import patch
from settings import Session
import notifications_manager as nm
from models.notification import Notification, NotificationChannel, NotificationStatus

from tests.fake_data_utils import fake
from pydantic import error_wrappers

@pytest.fixture
def db():
    return Session()

# Will run each test in the `yield` portion
@pytest.fixture(autouse=True)
def setup(db):
    db = Session()
    yield # this is where the testing happens
    db.rollback()

class MockResponse(object):
    def __init__(self, ok: bool):
        self.ok = ok

def test_notification_validation():
    with pytest.raises(error_wrappers.ValidationError):
        email_address = 123
        message = []
        nm.send_notification(email_address, message, NotificationChannel.EMAIL)

@patch('notifications_manager.SendGridAPIClient.send')
def test_validate_bad_email(mock_send, db):
    email_address = 'this is not an email'
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(email_address, message, NotificationChannel.EMAIL)

    notification = db.query(Notification).filter(Notification.recipient == email_address).first()

    assert notification.recipient == email_address
    assert not mock_send.called
    assert notification.status == NotificationStatus.FAILED
    assert notification.sent_date is None

    db.delete(notification)
    db.commit()

@patch('notifications_manager.SendGridAPIClient.send')
def test_send_email_success(mock_send, db):
    mock_send.return_value = MockResponse(True)

    email_address = 'good.email@example.com'
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(email_address, message, NotificationChannel.EMAIL)

    notification = db.query(Notification).filter(Notification.recipient == email_address).first()

    assert notification.channel == NotificationChannel.EMAIL
    assert notification.recipient == email_address
    assert notification.message == message
    assert notification.status == NotificationStatus.SENT
    assert notification.sent_date is not None

    db.delete(notification)
    db.commit()

@patch('notifications_manager.SendGridAPIClient.send')
def test_send_email_failure(mock_send, db):
    mock_send.return_value = MockResponse(False)

    email_address = 'good.email@example.com'
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(email_address, message, NotificationChannel.EMAIL)

    notification = db.query(Notification).filter(Notification.recipient == email_address).first()

    assert notification.status == NotificationStatus.FAILED
    assert notification.sent_date is None

    db.delete(notification)
    db.commit()
