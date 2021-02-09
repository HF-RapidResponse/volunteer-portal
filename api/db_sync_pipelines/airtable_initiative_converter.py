import json
from db_sync_pipelines.airtable_base_converter import AirtableBaseConverter
from models import Initiative


class AirtableInitiativeConverter(AirtableBaseConverter):
  sql_model = Initiative
  field_map = {
    "initiative_name": "fields.Initiative",
    "order": "fields.Portal Order",
    "details_url": "fields.Details Link",
    "hero_image_urls": "fields.Image",
    "content": "fields.Description",
    "role_ids": "fields.Volunteer Job Openings",
    "event_ids": "fields.Events"
  }

  custom_transforms = {}
