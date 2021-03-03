from datetime import datetime, timezone
from models.base import Base
import enum
from uuid import uuid4
from sqlalchemy import Column, Text, DateTime, Enum
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from uuid import uuid4


class NotificationChannel(enum.Enum):
    EMAIL = 'Email'
    SMS = 'SMS'
    SLACK = 'Slack'


class NotificationStatus(enum.Enum):
    SCHEDULED = 'Scheduled'
    SENT = 'Sent'
    FAILED = 'Failed'


class Notification(Base):
    __tablename__ = 'notifications'

    # TODO check this over - need to find all instances of notification_uuid
    uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    channel = Column('channel', Enum(NotificationChannel), nullable=False)
    recipient = Column('recipient', Text, nullable=False)
    # TODO subject nullable or title? need to check this over too where is trip using it/how
    title = Column('title', Text)
    message = Column('message', Text, nullable=False)
    scheduled_send_date = Column(
        'scheduled_send_date', DateTime, default=func.now(), nullable=False)
    status = Column('status', Enum(NotificationStatus),
                    default=NotificationStatus.SCHEDULED, nullable=False)
    sent_date = Column('send_date', DateTime)

    def __repr__(self):
        return "<Notification(uuid='%s', channel='%s', status='%s', )>" % (
                                self.uuid, self.channel, self.status)
