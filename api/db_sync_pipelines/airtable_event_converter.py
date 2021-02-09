import json
from db_sync_pipelines.api_response_converter import ParseISO8601Timestamp
from db_sync_pipelines.airtable_base_converter import AirtableBaseConverter
from models import VolunteerEvent


class AirtableEventConverter(AirtableBaseConverter):
  sql_model = VolunteerEvent
  field_map = {
    "event_name": "fields.Event Name",
    "hero_image_urls": "fields.Event Graphic(s)",
    "signup_url": "fields.Sign-Up Link",
    "start_datetime": "fields.Start",
    "end_datetime": "fields.End",
    "description": "fields.Description",
  }

  custom_transforms = {
      'start_datetime': ParseISO8601Timestamp,
      'end_datetime': ParseISO8601Timestamp,
  }
