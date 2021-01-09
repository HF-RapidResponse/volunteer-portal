from db_sync_pipelines.airtable_sync import RunAirtableSync, AirtableLoader
from db_sync_pipelines.airtable_event_converter import AirtableEventConverter

def RunEventsSync(db):
  table_name = "[Events]"
  table_key = 'appXC8UaNIuMXpnGB'
  airtable_loader = AirtableLoader(table_name, table_key, view="Humanity Forward Events")
  response_converter = AirtableEventConverter()

  RunAirtableSync(airtable_loader,
                  db,
                  response_converter,
                  hard_delete=False)
