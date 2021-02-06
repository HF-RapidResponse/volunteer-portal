import json
from db_sync_pipelines.api_response_converter import ParseISO8601Timestamp
from db_sync_pipelines.api_response_converter import ApiResponseConverter

class AirtableBaseConverter(ApiResponseConverter):

  base_field_map = {"external_id": "id",
                    "airtable_last_modified": "fields.Last Modified"}
  base_custom_transforms = {'airtable_last_modified': ParseISO8601Timestamp}
