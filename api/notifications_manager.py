from datetime import datetime
from pydantic import validate_arguments
from models.notification import Notification, NotificationChannel, NotificationStatus
from sqlalchemy.orm import Session as DBSession
from settings import Config, Session
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from email_validator import validate_email

email_client = SendGridAPIClient(Config['notifications']['sendgrid_api_key'])

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
        send_email_notification(notification, db)
    else:
        raise ValueError()

    db.commit()

@validate_arguments(config=dict(arbitrary_types_allowed=True))
def send_email_notification(notification: Notification, db: DBSession):
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
    
    except Exception:
        notification.status = NotificationStatus.FAILED
