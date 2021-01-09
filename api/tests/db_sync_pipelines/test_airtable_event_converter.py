import json
from db_sync_pipelines.airtable_event_converter import AirtableEventConverter
from datetime import datetime, timezone

def test_convert_fields():
  with open('tests/db_sync_pipelines/events_example_response.json') as f:
    example_response = json.loads(f.read())

  converter = AirtableEventConverter()
  first_event = example_response[0]

  result = converter.Convert(first_event)

  assert result.external_id == 'recXuvDiADvgunPBT_test'
  assert result.event_name == 'Humanity CALLS for Marilyn Strickland (w/ Andrew Yang)'
  assert type(result.hero_image_urls) == list
  assert result.hero_image_url == 'https://dl.airtable.com/.attachments/8d182ef5b3020efc193dd465814f5117/5b4ccc77/07.28.20Humanity_Hang.jpg'
  assert result.signup_url == 'https://movehumanityforward.zoom.us/meeting/register/tJYlcuipqj8oGNKH7oLiW5ma3rBBsBxFXA4Q'
  assert result.start_datetime == datetime(2020, 7, 25, 4, 0, tzinfo=timezone.utc)
  assert result.end_datetime == datetime(2020, 7, 25, 19, 0, tzinfo=timezone.utc)
  assert result.description == 'Test event description'
  assert result.airtable_last_modified == datetime(2020, 11, 20, 16, 42, 54, tzinfo=timezone.utc)
  assert result.airtable_last_modified and type(result.airtable_last_modified) == datetime
