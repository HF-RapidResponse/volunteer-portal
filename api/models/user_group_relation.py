from models.base import Base

import enum
from sqlalchemy import Column, Enum
from sqlalchemy.dialects.postgresql import UUID
from uuid import uuid4

class Relationship(enum.Enum):
    MEMBER = 'Member'
    ADMIN = 'Admin'
    BOOKMARK = 'Bookmark'

class UserGroupRelation(Base):
    __tablename__ = 'user_group_relations'

    uuid = Column(UUID(as_uuid=True), primary_key=True,
                  default=uuid4, unique=True, nullable=False)
    # uuid from accounts
    user_id = Column(UUID(as_uuid=True), nullable=False, index=True)

    # uuid from groups
    group_id = Column(UUID(as_uuid=True), nullable=False)

    relationship = Column('relationship', Enum(Relationship), nullable=False)

    def __repr__(self):
        return "<UserGroupRelation(uuid='%s', user_id='%s', group_id='%s', relationship='%s')>" % (
            self.uuid, self.user_id, self.group_id, self.relationship)
