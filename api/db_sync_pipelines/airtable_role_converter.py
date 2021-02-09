import json
from db_sync_pipelines.airtable_base_converter import AirtableBaseConverter
from models import VolunteerRole, Priority, RoleType

class AirtableRoleConverter(AirtableBaseConverter):
  sql_model = VolunteerRole
  field_map = {
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
  }

  custom_transforms = {
      'priority': Priority,
      'role_type': RoleType
  }
