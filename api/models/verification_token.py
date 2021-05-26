from datetime import datetime, timedelta
from models.base import Base
import enum
from uuid import uuid4
from pydantic import validate_arguments
from sqlalchemy import Column, DateTime, ForeignKey, Boolean, UniqueConstraint, BigInteger, Table
from sqlalchemy.orm import relationship, Session
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from uuid import uuid4
import pyotp

# this seed should not be hard-coded and instead use the portal_auth_personal_identifiers_otp_seed secret
# currently cannot use the Config object in any models due to circular dependency with settings.py
# ideally the DB initialization is factored out of loading and using config.yaml
otp_generator = pyotp.HOTP('OSY2VOJPGPGRIYDYW4TZXM5WOCHD7JTP')
valid_token_time_interval = timedelta(seconds=600)

def generate_otp_counter() -> int:
    # good enough to avoid majority of collisions (faster than a for loop)
    return otp_generator.at(int(datetime.now().timestamp()*100000))

class VerificationToken(Base):
    __tablename__ = 'verification_tokens'

    uuid = Column(UUID(as_uuid=True), primary_key=True, default=uuid4, unique=True, nullable=False)
    created_at = Column(DateTime, default=func.now(), nullable=False)
    already_used = Column(Boolean, default=False, nullable=False)
    _counter = Column('counter', BigInteger, default=generate_otp_counter, nullable=False)
    personal_identifier_uuid = Column(UUID(as_uuid=True), ForeignKey('personal_identifiers.uuid'))
    personal_identifier = relationship('PersonalIdentifier', foreign_keys=[personal_identifier_uuid], back_populates='verification_token')
    subscription_uuid = Column(UUID(as_uuid=True), ForeignKey('subscriptions.uuid'))
    subscription = relationship('Subscription', foreign_keys=[subscription_uuid], back_populates='verification_token')

    @hybrid_property
    def otp(self) -> str:
        assert not self.is_expired
        return otp_generator.at(self._counter)

    @hybrid_property
    def is_expired(self) -> bool:
        if not self.created_at:
            raise ValueError(f'Verification token has not been created in database')
        return datetime.now() > self.created_at + valid_token_time_interval

    @validate_arguments(config=dict(arbitrary_types_allowed=True))
    def verify(self, otp: str, session: Session) -> bool:
        if self.is_expired:
            raise ValueError(f'Verification token {self.uuid} has expired')
        elif self.already_used:
            raise ValueError(f'Verification token {self.uuid} has been previously successfully verified')

        verified = otp_generator.verify(otp, self._counter)
        if verified:
            self.already_used = True

            if self.personal_identifier:
                self.personal_identifier.verified = True
            if self.subscription:
                self.subscription.verified = True

            session.commit()

        return verified
