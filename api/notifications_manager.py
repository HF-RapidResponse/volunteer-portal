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

logging.basicConfig()
logging.getLogger('notifications_manager').setLevel(logging.INFO)

email_client = SendGridAPIClient(Config['notifications']['sendgrid_api_key'])
sms_client = Client(Config['notifications']['twilio_sid'], Config['notifications']['twilio_auth_token'])
slack_client = WebClient(token=Config['notifications']['slack_bot_auth_token'])

@validate_arguments(config=dict(arbitrary_types_allowed=True))
def send_notification(recipient: str, message: str, channel: NotificationChannel, scheduled_send_date: datetime = None):
    notification = Notification(
        recipient = recipient,
        message = message,
        channel = channel,
        scheduled_send_date = scheduled_send_date
    )
    
    db = Session()
    db.add(notification)

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
    try:
        assert notification.channel is NotificationChannel.EMAIL

        recipient_email_address = validate_email(notification.recipient).email

        email = Mail(
            from_email=Config['notifications']['email_default_from_address'],
            to_emails=recipient_email_address,
            subject='This is a test Vol Portal Email',
            html_content=f'<strong>Test email with message</strong> {notification.message}'
        )

        response = email_client.send(email)
        if response.ok:
            notification.status = NotificationStatus.SENT
            notification.sent_date = datetime.utcnow()
        else:
            notification.status = NotificationStatus.FAILED
    
    except Exception as e:
        logging.error(e)
        notification.status = NotificationStatus.FAILED

@validate_arguments(config=dict(arbitrary_types_allowed=True))
def send_sms_notification(notification: Notification):
    # this costs (a very small amount of) money each time we send a text; please test with another channel where possible
    try:
        assert notification.channel is NotificationChannel.SMS

        recipient_phone_number = phonenumbers.parse(notification.recipient, None)
        assert phonenumbers.is_valid_number(recipient_phone_number) is True

        response = sms_client.messages.create(
            from_=Config['notifications']['sms_default_from_number'],
            to=phonenumbers.format_number(recipient_phone_number, phonenumbers.PhoneNumberFormat.E164),
            body=notification.message
        )

        if response and not response.error_code:
            notification.status = NotificationStatus.SENT
            notification.sent_date = datetime.utcnow()
        else:
            notification.status = NotificationStatus.FAILED
    
    except Exception as e:
        logging.error(e)
        notification.status = NotificationStatus.FAILED

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
    
    except Exception as e:
        logging.error(e)
        notification.status = NotificationStatus.FAILED
