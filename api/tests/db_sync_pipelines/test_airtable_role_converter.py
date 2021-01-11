import json
from db_sync_pipelines.airtable_role_converter import AirtableRoleConverter
from models import Priority, RoleType
from datetime import datetime, timezone

def test_convert_fields():
  with open('tests/db_sync_pipelines/roles_example_response.json') as f:
    example_response = json.loads(f.read())

  converter = AirtableRoleConverter()
  first_event = example_response[0]

  result = converter.Convert(first_event)
  assert result.external_id == 'recapqTKNF97KJGBr'
  assert result.role_name == 'Team Lead'
  assert type(result.hero_image_urls) == list and type(result.hero_image_urls[0]) == dict
  assert result.hero_image_url == "https://dl.airtable.com/.attachments/1f6a1176be07c79fa1a7933e6c75e288/736de524/pexels-photo-3571094.jpeg"
  assert result.signup_url == 'https://airtable.com/shrPDKeg64PI5oYyt?prefill_All+Volunteer+Positions=Team%20Lead%20-%20Humanity%20TEXTS'
  assert result.details_url == None
  assert result.overview == 'The Team Lead for Texting will manage the Humanity Forward Texting...'
  assert result.benefits == '- Expert in managing Texting Campaigns\\n- How to build and retain...'
  assert result.priority == Priority('Top Priority')
  assert result.team == ['recFUK4YHha3DnrXM']
  assert result.team_lead_ids == ['recLxQ0EAN3jacrCs']
  assert result.num_openings == None
  assert result.min_time_commitment == 4
  assert result.max_time_commitment == 6
  assert result.responsibilities == '- Setup texting campaigns\\n- Manage the texting teams...'
  assert result.qualifications == '- Knowledge of the Spoke Texting platform\\n- Good language skills...'
  assert result.role_type == RoleType('Requires Application')
  assert result.airtable_last_modified == datetime(2020, 11, 20, 16, 42, 54, tzinfo=timezone.utc)
  assert type(result.db_last_modified) == datetime
