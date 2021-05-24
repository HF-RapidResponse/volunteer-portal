import logging
from datetime import datetime
from pydantic import validate_arguments
from models.notification import Notification, NotificationChannel, NotificationStatus
from settings import Config, Session
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from email_validator import validate_email
from twilio.rest import Client
import phonenumbers
from slack_sdk import WebClient
from urllib.request import urlopen

logging.getLogger(__name__).setLevel(logging.INFO)

email_client = SendGridAPIClient(Config['notifications']['sendgrid_api_key'])
sms_client = Client(Config['notifications']['twilio_sid'],
                    Config['notifications']['twilio_auth_token'])
slack_client = WebClient(token=Config['notifications']['slack_bot_auth_token'])


@validate_arguments(config=dict(arbitrary_types_allowed=True))
def send_notification(recipient: str, message: str, channel: NotificationChannel, title: str = None, scheduled_send_date: datetime = None):
    logging.info(f'Initiating a {channel.value} notification')
    notification = Notification(
        recipient = recipient,
        title = title,
        message = message,
        channel = channel,
        scheduled_send_date = scheduled_send_date
    )

    db = Session()
    db.add(notification)
    db.flush()

    if notification.channel is NotificationChannel.EMAIL:
        send_email_notification(notification)
    elif notification.channel is NotificationChannel.SMS:
        send_sms_notification(notification)
    elif notification.channel is NotificationChannel.SLACK:
        send_slack_notification(notification)
    else:
        raise ValueError()

    db.commit()


@validate_arguments(config=dict(arbitrary_types_allowed=True))
def send_email_notification(notification: Notification):
    logging.info(f'Attempting to send email notification {notification.uuid}')
    try:
        assert notification.channel is NotificationChannel.EMAIL

        recipient_email_address = validate_email(notification.recipient).email

        email = Mail(
            from_email=Config['notifications']['email_default_from_address'],
            to_emails=recipient_email_address,
            subject=notification.title if notification.title else f'An FYI from {Config["public_facing_org_name"]}',
            html_content=notification.message
        )

        response = email_client.send(email)

        if response.status_code < 300:
            notification.status = NotificationStatus.SENT
            notification.sent_date = datetime.utcnow()
            logging.info(f'Successfully sent email notification {notification.uuid}')
        else:
            notification.status = NotificationStatus.FAILED
            logging.error(f'Failed to send email notification {notification.uuid}')

    except Exception as e:
        notification.status = NotificationStatus.FAILED
        logging.error(f'Failed to send email notification {notification.uuid} with error {e}')


@validate_arguments(config=dict(arbitrary_types_allowed=True))
def send_sms_notification(notification: Notification):
    # this costs (a very small amount of) money each time we send a text; please test with another channel where possible
    try:
        assert notification.channel is NotificationChannel.SMS

        recipient_phone_number = phonenumbers.parse(
            notification.recipient, None)
        assert phonenumbers.is_valid_number(recipient_phone_number) is True

        response = sms_client.messages.create(
            from_=Config['notifications']['sms_default_from_number'],
            to=phonenumbers.format_number(
                recipient_phone_number, phonenumbers.PhoneNumberFormat.E164),
            body=notification.message
        )

        if response and not response.error_code:
            notification.status = NotificationStatus.SENT
            notification.sent_date = datetime.utcnow()
            logging.info(f'Successfully sent sms notification {notification.uuid}')
        else:
            notification.status = NotificationStatus.FAILED
            logging.error(f'Failed to send sms notification {notification.uuid}')

    except Exception as e:
        notification.status = NotificationStatus.FAILED
        logging.error(f'Failed to send sms notification {notification.uuid} with error {e}')


@validate_arguments(config=dict(arbitrary_types_allowed=True))
def send_slack_notification(notification: Notification):
    try:
        assert notification.channel is NotificationChannel.SLACK

        slack_client.chat_postMessage(
            channel=notification.recipient,
            text=notification.message
        )

        # WebClient automatically raises a SlackApiError if response.ok is False; no need to check
        notification.status = NotificationStatus.SENT
        notification.sent_date = datetime.utcnow()
        logging.info(f'Successfully sent slack notification {notification.uuid}')

    except Exception as e:
        notification.status = NotificationStatus.FAILED
        logging.error(f'Failed to send slack notification {notification.uuid} with error {e}')
