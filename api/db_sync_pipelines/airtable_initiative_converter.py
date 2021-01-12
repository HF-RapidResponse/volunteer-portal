import json
from datetime import datetime
from datetime import timezone
from db_sync_pipelines.airtable_sync import GetNowTimestamp, ParseTimestamp
from db_sync_pipelines.api_response_converter import ApiResponseConverter
from models import Initiative


class AirtableInitiativeConverter(ApiResponseConverter):
  sql_model = Initiative
  field_map = {
    "external_id": "id",
    "initiative_name": "fields.Initiative",
    "order": "fields.Portal Order",
    "details_url": "fields.Details Link",
    "hero_image_urls": "fields.Image",
    "content": "fields.Description",
    "airtable_last_modified": "fields.Last Modified",
    "role_ids": "fields.Volunteer Job Openings",
    "event_ids": "fields.Events"
  }

  additional_fields = {"db_last_modified": GetNowTimestamp}
  custom_transforms = {
      'airtable_last_modified': ParseTimestamp,
  }
