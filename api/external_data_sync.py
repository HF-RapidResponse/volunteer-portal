from fastapi import APIRouter, Depends
from fastapi.responses import HTMLResponse
import logging

from db_sync_pipelines.pipelines import RunEventsSync, RunRolesSync, RunInitiavesSync, RunTestEventsSync
from settings import Config, Session, get_db, ENV

router = APIRouter()

RESPONSE_TEMPLATE_OUTER = """<!DOCTYPE html>
<head>
  <title>Run Data Sync</title>
</head>
<body>
  <h2>Sync Complete. Issues Found <b>{len_errors}</b>:</h2>
  <ol>
  {error_list}
  </ol>
</body>
"""

def MakeHTMLErrorList(errors):
    s = ""
    for record, error in errors:
        print(record, "AAAAAAAA")
        s+= f'<li style="white-space: pre-line;">{record} <ul><li>{error}</li></ul></li>'
    return s

def SyncRunner(db, sync_fn) -> str:
    try:
        errors = sync_fn(db)
    except Exception as e:
        logging.warning(f"Failed to sync {sync_fn}:\n {e}")
        return "Failed to sync: " + str(e)
    error_list = MakeHTMLErrorList(errors)
    return RESPONSE_TEMPLATE_OUTER.format(len_errors=len(errors),
                                          error_list=error_list)

@router.get("/run_events_sync/", response_class=HTMLResponse)
def run_events_sync(db: Session = Depends(get_db)) -> str:
    return SyncRunner(db, RunEventsSync)

@router.get("/run_roles_sync/", response_class=HTMLResponse)
def run_roles_sync(db: Session = Depends(get_db)) -> str:
    return SyncRunner(db, RunRolesSync)

@router.get("/run_initiatives_sync/", response_class=HTMLResponse)
def run_initiatives_sync(db: Session = Depends(get_db)) -> str:
    return SyncRunner(db, RunInitiavesSync)

@router.get("/run_test_event_sync/", response_class=HTMLResponse)
def run_initiatives_sync(db: Session = Depends(get_db)) -> str:
    if ENV == 'production':
        return "Cannot sync test data in production"
    return SyncRunner(db, RunTestEventsSync)
