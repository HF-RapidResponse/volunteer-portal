import json
from datetime import datetime
from datetime import timezone
from db_sync_pipelines.airtable_sync import GetNowTimestamp, ParseTimestamp
from db_sync_pipelines.api_response_converter import ApiResponseConverter
from models import VolunteerRole, Priority, RoleType

class AirtableRoleConverter(ApiResponseConverter):
  sql_model = VolunteerRole
  field_map = {
    "external_id": "id",
    "role_name": "fields.Position Title",
    "hero_image_urls": "fields.Team Photo",
    "signup_url": "fields.Application/Signup Form",
    "details_url":"fields.More Info Link",
    "overview": "fields.Job Overview",
    "benefits": "fields.What You'll Learn",
    "priority": "fields.Priority Level",
    "team": "fields.Team",
    "team_lead_ids": "fields.Team Lead(s)",
    "num_openings": "fields.# of Openings",
    "min_time_commitment": "fields.Minimum time commitment per week (Hours)",
    "max_time_commitment": "fields.Maximum time commitment per week (Hours)",
    "responsibilities": "fields.Responsibilities & Duties",
    "qualifications": "fields.Qualifications",
    "role_type": "fields.Role Type",
    "airtable_last_modified": "fields.Last Modified",
  }

  additional_fields = {"db_last_modified": GetNowTimestamp}
  custom_transforms = {
      'airtable_last_modified': ParseTimestamp,
      'priority': Priority,
      'role_type': RoleType
  }
