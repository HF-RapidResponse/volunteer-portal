import pytest
import json
from db_sync_pipelines.airtable_event_converter import AirtableEventConverter
from db_sync_pipelines.airtable_sync import RunAirtableSync, AIRTABLE_DATETIME_FORMAT
from models import VolunteerEvent
from datetime import datetime, timezone, timedelta
from settings import Session
from sqlalchemy import and_

@pytest.fixture
def db():
    return Session()

@pytest.fixture
def response_converter():
    return AirtableEventConverter()

@pytest.fixture
def airtable_loader():
    return FakeAirtableLoader('events_example_response.json')

def cleanup(db):
    # additional teardown is needed to remove
    # db changes commited (can't be rolled back) in RunAirtableSync
    db.query(VolunteerEvent)\
      .filter(VolunteerEvent.external_id.like("%_test"))\
      .delete(synchronize_session=False)
    db.commit()

# Will run each test in the `yield` portion
@pytest.fixture(autouse=True)
def setup(db, response_converter, airtable_loader):
    db = Session()

    RunAirtableSync(airtable_loader, db, response_converter)

    yield # this is where the testing happens
    db.rollback()
    cleanup(db)

class FakeAirtableLoader():
  def __init__(self, response_file):
    with open("/".join(['tests/db_sync_pipelines', response_file])) as f:
        self.response = json.loads(f.read())

  def GetTable(self):
    return self.response

def test_event_sync_and_setup(db, response_converter):
  response_converter.GetDBModel()
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
  assert event1.updated_at and type(event1.updated_at) == datetime

def test_event_sync_soft_delete(db, airtable_loader, response_converter):
  del airtable_loader.response[0]
  RunAirtableSync(airtable_loader, db, response_converter, hard_delete=False)

  saved_test_events = db.query(VolunteerEvent).filter(VolunteerEvent.external_id.like("%_test")).count()
  assert saved_test_events == 3

  soft_deleted_events = db.query(VolunteerEvent)\
                          .filter(and_(VolunteerEvent.external_id.like("%_test"), VolunteerEvent.is_deleted))\
                          .count()
  assert soft_deleted_events == 1

def test_event_sync_hard_delete(db, airtable_loader, response_converter):
  del airtable_loader.response[0]
  RunAirtableSync(airtable_loader, db, response_converter, hard_delete=True)

  saved_test_events = db.query(VolunteerEvent).filter(VolunteerEvent.external_id.like("%_test")).count()
  assert saved_test_events == 2

  soft_deleted_events = db.query(VolunteerEvent)\
                          .filter(and_(VolunteerEvent.external_id.like("%_test"), VolunteerEvent.is_deleted))\
                          .count()
  assert soft_deleted_events == 0

def test_update(db, airtable_loader, response_converter):
  event = airtable_loader.response[0]
  event_id = event['id']
  event['fields']['Description'] = "Updated"
  event['fields']['Last Modified'] = (datetime.now(tz=timezone.utc)
                                      + timedelta(minutes=1)).strftime(AIRTABLE_DATETIME_FORMAT)

  initial_timestamp, initial_description = db.query(VolunteerEvent.updated_at, VolunteerEvent.description)\
                                             .filter(VolunteerEvent.external_id == event_id).first()
  assert initial_description != "updated"

  RunAirtableSync(airtable_loader, db, response_converter)

  assert db.query(VolunteerEvent).filter(VolunteerEvent.external_id == event_id).count() == 1
  saved_event = db.query(VolunteerEvent).filter(VolunteerEvent.external_id == event_id).first()
  assert saved_event.description == "Updated"
  assert saved_event.updated_at > initial_timestamp

def test_missing_nonnullable_field_fails(db, airtable_loader, response_converter):
  event = airtable_loader.response[0]
  event['id'] = "missing_nonnullable_id_test"
  event_id = event['id']
  del event['fields']['Event Name']
  event['fields']['Start'] = None

  with pytest.raises(Exception) as e:
      RunAirtableSync(airtable_loader, db, response_converter)

  assert "event_name" in str(e) or 'start_datetime' in str(e)
