import json
from db_sync_pipelines.airtable_initiative_converter import AirtableInitiativeConverter
from datetime import datetime, timezone

def test_convert_fields():
  with open('tests/db_sync_pipelines/initiatives_example_response.json') as f:
    example_response = json.loads(f.read())

  converter = AirtableInitiativeConverter()
  first_initiative = example_response[0]

  result = converter.Convert(first_initiative)

  assert result.external_id == 'recg36ZZWG7QaP7Sg'
  assert result.initiative_name == 'Fundraising for UBI campaign'
  assert result.order == 1
  assert result.details_url == 'https://on.movehumanityforward.com/ubi'
  assert result.hero_image_urls == None
  assert result.content == 'We know UBI will protect our people from the economic ravages of pandemic...'
  assert result.role_ids == ['reclVwU0KldZXD0L8', 'reca7NWt4Kll3261m', 'recapqTKNF97KJGBr']
  assert result.event_ids == ['rec2qTo8hpgyCvblo']
  assert result.airtable_last_modified == datetime(2020, 12, 21, 22, 56, 59, tzinfo=timezone.utc)
  assert type(result.db_last_modified) == datetime
