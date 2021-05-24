from sqlalchemy import Column, String, Text, DateTime, Boolean
from sqlalchemy.sql import func

class AirtableRow():
  external_id = Column('id', String(255), nullable=False, unique=True)
  airtable_last_modified = Column('airtable_last_modified', DateTime, nullable=False)
  updated_at = Column('updated_at', DateTime, onupdate=func.now(), default=func.now(), nullable=False)
  is_deleted = Column('is_deleted', Boolean, nullable=False, default=False)
