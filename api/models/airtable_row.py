from sqlalchemy import Column, String, Text, DateTime, Boolean
from sqlalchemy.sql import func

class AirtableRow():
  external_id = Column(String(255), nullable=False, unique=True)
  airtable_last_modified = Column(DateTime, nullable=False)
  updated_at = Column(DateTime, onupdate=func.now(), default=func.now(), nullable=False)
  is_deleted = Column(Boolean, nullable=False, default=False)
