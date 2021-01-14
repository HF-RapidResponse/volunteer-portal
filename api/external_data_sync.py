from fastapi import APIRouter, Depends
import logging

from db_sync_pipelines.pipelines import RunEventsSync, RunRolesSync, RunInitiavesSync
from settings import Config, Session, get_db

router = APIRouter()

def SyncRunner(db, sync_fn) -> str:
    try:
        sync_fn(db)
    except Exception as e:
        logging.warning(f"Failed to sync {sync_fn}:\n {e}")
        return "Failed to sync"
    return "Done"

@router.get("/run_events_sync/")
def run_events_sync(db: Session = Depends(get_db)) -> str:
    return SyncRunner(db, RunEventsSync)

@router.get("/run_roles_sync/")
def run_roles_sync(db: Session = Depends(get_db)) -> str:
    return SyncRunner(db, RunRolesSync)

@router.get("/run_initiatives_sync/")
def run_initiatives_sync(db: Session = Depends(get_db)) -> str:
    return SyncRunner(db, RunInitiavesSync)
