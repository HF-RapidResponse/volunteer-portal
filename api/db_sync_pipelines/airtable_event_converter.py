import json
from datetime import datetime
from datetime import timezone
from db_sync_pipelines.airtable_sync import GetNowTimestamp, ParseTimestamp
from db_sync_pipelines.api_response_converter import ApiResponseConverter
from models import VolunteerEvent


class AirtableEventConverter(ApiResponseConverter):
  sql_model = VolunteerEvent
  field_map = {
    "external_id": "id",
    "event_name": "fields.Event Name",
    "hero_image_urls": "fields.Event Graphic(s)",
    "signup_url": "fields.Sign-Up Link",
    "start_datetime": "fields.Start",
    "end_datetime": "fields.End",
    "description": "fields.Description",
    "airtable_last_modified": "fields.Last Modified",
  }

  custom_transforms = {
      'start_datetime': ParseTimestamp,
      'end_datetime': ParseTimestamp,
      'airtable_last_modified': ParseTimestamp,
  }
