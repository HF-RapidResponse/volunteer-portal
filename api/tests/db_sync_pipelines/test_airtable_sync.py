import pytest
import json
from db_sync_pipelines.airtable_event_converter import AirtableEventConverter
from db_sync_pipelines.airtable_sync import RunAirtableSync
from models import VolunteerEvent
from datetime import datetime, timezone
from settings import Session

import logging
logging.basicConfig(level=logging.DEBUG)

@pytest.fixture
def db():
    return Session()


# Will run each test in the `yield` portion
@pytest.fixture(autouse=True)
def setup(db):
    db = Session()
    yield # this is where the testing happens
    db.rollback()

class FakeAirtableLoader():
  def __init__(self, response_file):
    self.response_file = response_file
    
  def GetTable(self):
    with open("/".join(['tests/db_sync_pipelines', self.response_file])) as f:
      return json.loads(f.read())

def test_event_sync(db):
  airtable_loader = FakeAirtableLoader('events_example_response.json')
  response_converter = AirtableEventConverter()

  RunAirtableSync(airtable_loader,
                  db,
                  response_converter,
                  hard_delete=False)

  saved_test_events = db.query(VolunteerEvent).filter(VolunteerEvent.external_id.like("%_test")).all()
  assert len(saved_test_events) == 3

  event1 = db.query(VolunteerEvent).filter(VolunteerEvent.external_id == "recXuvDiADvgunPBT_test").first()

  assert event1.external_id == 'recXuvDiADvgunPBT_test'
  assert event1.event_name == 'Humanity CALLS for Marilyn Strickland (w/ Andrew Yang)'
  assert type(event1.hero_image_urls) == list
  assert event1.hero_image_url == 'https://dl.airtable.com/.attachments/8d182ef5b3020efc193dd465814f5117/5b4ccc77/07.28.20Humanity_Hang.jpg'
  assert event1.signup_url == 'https://movehumanityforward.zoom.us/meeting/register/tJYlcuipqj8oGNKH7oLiW5ma3rBBsBxFXA4Q'
  # Timezone is stripped by inserting it into the DB ("timestamp without time zone" type field)
  assert event1.start_datetime == datetime(2020, 7, 25, 4, 0)
  assert event1.end_datetime == datetime(2020, 7, 25, 19, 0)
  assert event1.description == 'Test event description'
  assert event1.airtable_last_modified == datetime(2020, 11, 20, 16, 42, 54)
  assert event1.airtable_last_modified and type(event1.airtable_last_modified) == datetime

  
