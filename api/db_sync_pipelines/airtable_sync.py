from google.cloud import secretmanager
from airtable import Airtable
import logging
import json
from datetime import datetime
from datetime import timezone
import re

AIRTABLE_DATETIME_FORMAT = '%Y-%m-%dT%H:%M:%S.%f%z'
PROJECT_ID = "humanity-forward"

def GetNowTimestamp():
  return datetime.now(tz=timezone.utc)


def ParseTimestamp(timestamp):
  if not timestamp:
      return None
  return datetime.strptime(timestamp, AIRTABLE_DATETIME_FORMAT)


class AirtableLoader:
    def __init__(self, airtable_name, airtable_key, view):
        self.airtable_name = airtable_name
        self.airtable_key = airtable_key
        self.view = view

        secret_client = secretmanager.SecretManagerServiceClient()
        self.airtable_client = GetAirtableClient(airtable_key, airtable_name, secret_client)

    def GetTable(self):
        return self.airtable_client.get_all(view=self.view)

def RunAirtableSync(airtable_loader,
                    db,
                    response_converter,
                    airtable_view=None,
                    hard_delete=False):

    db_model = response_converter.GetDBModel()
    all_records = list(GetAndConvertAirtableRecords(
        airtable_loader, response_converter, airtable_view))
    existing_record_ids = GetExistingRecordIds(db, db_model, hard_delete)
    latest_sync_run = GetLatestSyncRun(db, db_model)

    new_records = []
    updated_records = []

    for record in all_records:
        if record.external_id not in existing_record_ids:
            new_records.append(record)
        elif NeedsUpdate(record, latest_sync_run):
            updated_records.append(record)

    airtable_records = set([record.external_id for record in all_records])
    deleted_records = existing_record_ids - airtable_records

    if new_records:
        logging.debug(f"inserting {len(new_records)} records.")
        InsertRecords(new_records, db)

    if updated_records:
        logging.debug(f"updating {len(updated_records)} records.")
        UpdateRecords(updated_records, db, db_model)

    if deleted_records and not hard_delete:
        logging.debug(f"marking {len(deleted_records)} records as deleted.")
        UpdateRecordsAsDeleted(deleted_records, db, db_model)
    elif deleted_records and hard_delete:
        logging.debug(f"deleting {len(deleted_records)} records.")
        DeleteRecords(deleted_records, db, db_model)

def GetAirtableClient(table_key, table_name, secret_client):
    # Load SQL and airtable credentials from secretmanager
    secret_path = f'projects/{PROJECT_ID}/secrets/airtable-api-key/versions/latest'
    AIRTABLE_API_KEY = secret_client.access_secret_version(
        request={"name": secret_path}).payload.data.decode('UTF-8')
    return Airtable(table_key, table_name, api_key=AIRTABLE_API_KEY)


def GetAndConvertAirtableRecords(airtable_loader,
                                 response_converter,
                                 view=None):
    for r in airtable_loader.GetTable():
        yield response_converter.Convert(r)


def GetExistingRecordIds(db, db_model, hard_delete=False):
    query = db.query(db_model.external_id)
    if not hard_delete:
        query = query.filter(db_model.is_deleted == False)

    ids = set([x.external_id for x in query.all()])
    return ids


def GetLatestSyncRun(db, db_model):
    query = db.query(db_model.updated_at).order_by(db_model.updated_at.desc())
    result = query.first()
    return result[0].replace(tzinfo=timezone.utc) if result else None


def NeedsUpdate(record, latest_job_run):
    if not record.airtable_last_modified or not latest_job_run:
        return True
    last_record_update = record.airtable_last_modified
    last_record_update = last_record_update.replace(tzinfo=timezone.utc)
    return latest_job_run < last_record_update


acc_types = set([int, float, str, bool, bytes, type(None)])


def AcceptableSQLVal(val):
    return type(val) in acc_types


re_char_pattern = re.compile(u'[^\u0000-\uD7FF\uE000-\uFFFF]', re.UNICODE)


def filter_using_re(unicode_string):
    return re_char_pattern.sub(u'_', unicode_string)


def InsertRecords(db_records, db):
    # TODO check Insert Non-acceptableSqlValues
    try:
        db.bulk_save_objects(db_records)
        db.commit()
    except Exception as e:
        logging.warning('Failed to execute %s queries: %s' % (len(db_records), e))
        raise


def UpdateRecords(local_records, db, db_model):
    try:
        for local_record in local_records:
            # TODO update external_id to uuid once we move to postres
            # this looks unnecessary step when the primary key is the external_id(airtable recordId)
            # but will be necessary when we move to a uuid primary key.
            # there is almost certainly a better way to do this insert/update syncing logic with
            # sqlAlchemy.
            record_uid, = db.query(db_model.external_id).filter(
                db_model.external_id == local_record.external_id).first()
            local_record.externel_id = record_uid

        db.commit()
    except Exception as e:
        logging.warning('Failed to execute queries: %s' % e)
        raise


def UpdateRecordsAsDeleted(to_delete, db, db_model):
    try:
        db.query(db_model)\
          .filter(db_model.external_id.in_(to_delete))\
          .update({"is_deleted": True}, synchronize_session='fetch')
        db.commit()
    except Exception as e:
        logging.warning('Failed to execute queries: %s' % e)
        raise

def DeleteRecords(to_delete, db, db_model):
    try:
        db.query(db_model)\
          .filter(db_model.external_id.in_(to_delete))\
          .delete(synchronize_session='fetch')
        db.commit()
    except Exception as e:
        logging.warning('Failed to execute queries: %s' % e)
        raise
