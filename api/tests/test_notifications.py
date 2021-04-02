import pytest
from unittest.mock import patch
from settings import Session
import notifications_manager as nm
from models.notification import Notification, NotificationChannel, NotificationStatus
from slack_sdk.errors import SlackApiError

from tests.fake_data_utils import fake
from pydantic import error_wrappers


@pytest.fixture
def db():
    return Session()

# Will run each test in the `yield` portion


@pytest.fixture(autouse=True)
def setup(db):
    db = Session()
    yield  # this is where the testing happens
    db.rollback()


class MockResponse(object):
    def __init__(self, success: bool):
        # mocks request.reponse behavior returned by SendGrid
        self.ok = success
        self.status_code = 202
        # mocks object from Twilio response
        self.error_code = None if success else 1234


def test_notification_validation():
    with pytest.raises(error_wrappers.ValidationError):
        recipient = 123
        message = []
        nm.send_notification(recipient, message, 'email')


@patch('notifications_manager.email_client.send')
def test_validate_bad_email(mock_send, db):
    bad_email_address = 'this is not an email'
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(bad_email_address, message, NotificationChannel.EMAIL)

    notification = db.query(Notification).filter(
        Notification.recipient == bad_email_address).first()

    assert notification.recipient == bad_email_address
    assert not mock_send.called
    assert notification.status == NotificationStatus.FAILED
    assert notification.sent_date is None

    db.delete(notification)
    db.commit()


@patch('notifications_manager.email_client.send')
def test_send_email_success(mock_send, db):
    mock_send.return_value = MockResponse(True)

    email_address = 'good.email@exmaple.com'
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(email_address, message, NotificationChannel.EMAIL)

    notification = db.query(Notification).filter(
        Notification.recipient == email_address).first()

    assert notification.channel == NotificationChannel.EMAIL
    assert notification.recipient == email_address
    assert notification.message == message
    assert notification.status == NotificationStatus.SENT
    assert notification.sent_date is not None

    db.delete(notification)
    db.commit()


@patch('notifications_manager.email_client.send')
def test_send_email_failure(mock_send, db):
    mock_send.return_value = MockResponse(False)

    email_address = 'asdf@!'
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(email_address, message, NotificationChannel.EMAIL)

    notification = db.query(Notification).filter(
        Notification.recipient == email_address).first()

    assert notification.status == NotificationStatus.FAILED
    assert notification.sent_date is None

    db.delete(notification)
    db.commit()


@patch('notifications_manager.sms_client.messages.create')
def test_validate_bad_phone_number(mock_send, db):
    bad_phone_number = '123456'
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(bad_phone_number, message, NotificationChannel.SMS)

    notification = db.query(Notification).filter(
        Notification.recipient == bad_phone_number).first()

    assert notification.recipient == bad_phone_number
    assert not mock_send.called
    assert notification.status == NotificationStatus.FAILED
    assert notification.sent_date is None

    db.delete(notification)
    db.commit()


@patch('notifications_manager.sms_client.messages.create')
def test_send_sms_success(mock_send, db):
    mock_send.return_value = MockResponse(True)

    phone_number = '+1 1-800-444-4444'
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(phone_number, message, NotificationChannel.SMS)

    notification = db.query(Notification).filter(
        Notification.recipient == phone_number).first()

    assert mock_send.called
    assert notification.channel == NotificationChannel.SMS
    assert notification.recipient == phone_number
    assert notification.message == message
    assert notification.status == NotificationStatus.SENT
    assert notification.sent_date is not None

    db.delete(notification)
    db.commit()


@patch('notifications_manager.sms_client.messages.create')
def test_send_sms_failure(mock_send, db):
    mock_send.return_value = MockResponse(False)

    phone_number = fake.phone_number()
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(phone_number, message, NotificationChannel.SMS)

    notification = db.query(Notification).filter(
        Notification.recipient == phone_number).first()

    assert notification.status == NotificationStatus.FAILED
    assert notification.sent_date is None

    db.delete(notification)
    db.commit()


@patch('notifications_manager.slack_client.chat_postMessage')
def test_send_slack_success(mock_send, db):
    mock_send.return_value = MockResponse(True)

    slack_user_id = 'not a real slack user ID'
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(slack_user_id, message, NotificationChannel.SLACK)

    notification = db.query(Notification).filter(
        Notification.recipient == slack_user_id).first()

    assert mock_send.called
    assert notification.channel == NotificationChannel.SLACK
    assert notification.recipient == slack_user_id
    assert notification.message == message
    assert notification.status == NotificationStatus.SENT
    assert notification.sent_date is not None

    db.delete(notification)
    db.commit()


@patch('notifications_manager.slack_client.chat_postMessage')
def test_send_slack_failure(mock_send, db):
    mock_send.side_effect = SlackApiError(None, None)

    slack_user_id = 'still not a real slack user ID'
    message = fake.paragraph(nb_sentences=10)
    nm.send_notification(slack_user_id, message, NotificationChannel.SLACK)

    notification = db.query(Notification).filter(
        Notification.recipient == slack_user_id).first()

    assert notification.status == NotificationStatus.FAILED
    assert notification.sent_date is None

    db.delete(notification)
    db.commit()
