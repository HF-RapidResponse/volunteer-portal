from db_sync_pipelines.airtable_sync import RunAirtableSync, AirtableLoader, FakeAirtableLoader
from db_sync_pipelines.airtable_event_converter import AirtableEventConverter
from db_sync_pipelines.airtable_role_converter import AirtableRoleConverter
from db_sync_pipelines.airtable_initiative_converter import AirtableInitiativeConverter

def RunEventsSync(db):
  table_name = "[Events]"
  table_key = 'appXC8UaNIuMXpnGB'
  airtable_loader = AirtableLoader(table_name, table_key, view="Humanity Forward Events")
  response_converter = AirtableEventConverter()
  return RunAirtableSync(airtable_loader,
                         db,
                         response_converter,
                         hard_delete=False)

def RunRolesSync(db):
  table_name = 'Volunteer Job Openings'
  table_key = 'appXC8UaNIuMXpnGB'
  airtable_loader = AirtableLoader(table_name, table_key, view='Public Volunteer Openings')
  response_converter = AirtableRoleConverter()
  return RunAirtableSync(airtable_loader,
                         db,
                         response_converter,
                         hard_delete=False)

def RunInitiavesSync(db):
  table_name = 'Volunteer Initiatives'
  table_key = 'appXC8UaNIuMXpnGB'
  airtable_loader = AirtableLoader(table_name, table_key, view='Published Initiatives')
  response_converter = AirtableInitiativeConverter()
  return RunAirtableSync(airtable_loader,
                         db,
                         response_converter,
                         hard_delete=False)

def RunTestEventsSync(db):
  airtable_loader = FakeAirtableLoader('events_example_response.json')
  response_converter = AirtableEventConverter()
  return RunAirtableSync(airtable_loader,
                         db,
                         response_converter,
                         hard_delete=False)
