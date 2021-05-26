import enum
from uuid import uuid4
from sqlalchemy import Column, Enum, ForeignKey, Index, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.dialects.postgresql import UUID
from models.base import Base

class SubscriptionEntity(enum.Enum):
    INITIATIVE = 'initiative'

class Subscription(Base):
    __tablename__ = 'subscriptions'

    def __init__(self, *args, **kwargs):
      super().__init__(*args, **kwargs)
      if 'identifier_uuid' in kwargs or 'account_uuid' in kwargs:
        raise Exception("please use the setters for account or identifier")

    uuid = Column(UUID(as_uuid=True), primary_key=True,
                  default=uuid4, unique=True, nullable=False)

        # Type of thing being subscribed to
    entity_type = Column(Enum(SubscriptionEntity), nullable=False)
    entity_uuid = Column(UUID(as_uuid=True), nullable=True)

    # This is a separate verification from the identifer.
    # each subscriptions must be verified even if the identifier has been verified before.
    verified = Column(Boolean, default=False, nullable=False)
    verification_token = relationship('VerificationToken', back_populates='subscription', uselist=False, cascade='delete')

    identifier_uuid = Column(UUID(as_uuid=True), ForeignKey('personal_identifiers.uuid'),
                             nullable=True)

    account_uuid = Column(UUID(as_uuid=True), ForeignKey('accounts.uuid'))
    _identifier = relationship('PersonalIdentifier', foreign_keys=[identifier_uuid])
    _account = relationship('Account', foreign_keys=[account_uuid])



    __table_args__ = (Index('ix_sub_account_uuid', 'account_uuid', postgresql_using='hash'),
                      Index('ix_sub_id_uuid', 'identifier_uuid', postgresql_using='hash'),)

    @hybrid_property
    def account(self):
        return self._account

    @account.setter
    def account(self, account):
        if not account:
            return
        self._account = account
        if account.primary_email_identifier:
            self.identifier_uuid = account.primary_email_identifier.uuid

    @hybrid_property
    def identifier(self):
        return self._identifier

    @identifier.setter
    def identifier(self, identifier):
        if not identifier:
            return
        self._identifier = identifier
        if identifier.account:
            self.account_uuid = identifier.account.uuid
