from google.cloud import secretmanager
from airtable import Airtable
import logging
import json
from datetime import timezone
import re

PROJECT_ID = "humanity-forward"


class AirtableLoader:
    def __init__(self, airtable_name, airtable_key, view):
        self.airtable_name = airtable_name
        self.airtable_key = airtable_key
        self.view = view

        secret_client = secretmanager.SecretManagerServiceClient()
        self.airtable_client = GetAirtableClient(airtable_key, airtable_name, secret_client)

    def GetTable(self):
        return self.airtable_client.get_all(view=self.view)

class FakeAirtableLoader():
  def __init__(self, response_file):
    with open("/".join(['tests/db_sync_pipelines', response_file])) as f:
        self.response = json.loads(f.read())

  def GetTable(self):
    return self.response


def RunAirtableSync(airtable_loader,
                    db,
                    response_converter,
                    airtable_view=None,
                    hard_delete=False):

    db_model = response_converter.GetDBModel()
    all_records = GetAndConvertAirtableRecords(
        airtable_loader, response_converter, airtable_view)
    existing_record_ids = GetExistingRecordIds(db, db_model, hard_delete)
    latest_sync_run = GetLatestSyncRun(db, db_model)

    new_records = []
    updated_records = []

    for record in all_records:
        if record.external_id not in existing_record_ids:
            new_records.append(record)
        elif NeedsUpdate(record, latest_sync_run):
            updated_records.append(record)

    airtable_record_ids = set([record.external_id for record in all_records])
    deleted_records = existing_record_ids - airtable_record_ids

    errors = []
    if new_records:
        logging.debug(f"inserting {len(new_records)} records.")
        errors += InsertRecords(new_records, db)

    if updated_records:
        logging.debug(f"updating {len(updated_records)} records.")
        errors += UpdateRecords(updated_records, db, db_model)

    if deleted_records and not hard_delete:
        logging.debug(f"marking {len(deleted_records)} records as deleted.")
        errors += UpdateRecordsAsDeleted(deleted_records, db, db_model)
    elif deleted_records and hard_delete:
        logging.debug(f"deleting {len(deleted_records)} records.")
        errors += DeleteRecords(deleted_records, db, db_model)

    return errors
def GetAirtableClient(table_key, table_name, secret_client):
    # Load SQL and airtable credentials from secretmanager
    secret_path = f'projects/{PROJECT_ID}/secrets/airtable-api-key/versions/latest'
    AIRTABLE_API_KEY = secret_client.access_secret_version(
        request={"name": secret_path}).payload.data.decode('UTF-8')
    return Airtable(table_key, table_name, api_key=AIRTABLE_API_KEY)


def GetAndConvertAirtableRecords(airtable_loader,
                                 response_converter,
                                 view=None):
    return [response_converter.Convert(r) for r in airtable_loader.GetTable()]


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
    # There is no way to have sqlAlchemy check the records are valid locally before committing.
    for r in db_records:
        try:
            db.add(r)
            db.commit()
        except Exception as e:
            logging.warning('Failed to execute query: %s' % e)
            db.rollback()
            yield (r, e)


def UpdateRecords(local_records, db, db_model):
    errors = []
    for local_record in local_records:
        # Feels like there should be a better way to do this.
        try:
            db.query(db_model).filter(
                db_model.external_id == local_record.external_id).delete()
            db.add(local_record)
            db.commit()
        except Exception as e:
            logging.warning('Failed to execute query: %s' % e)
            db.rollback()
            yield (local_record, e)


def UpdateRecordsAsDeleted(to_delete, db, db_model):
    try:
        db.query(db_model)\
          .filter(db_model.external_id.in_(to_delete))\
          .update({"is_deleted": True}, synchronize_session='fetch')
        db.commit()
    except Exception as e:
        logging.warning('Failed to execute queries: %s' % e)
        yield (f'{len(to_delete)} records', e)

def DeleteRecords(to_delete, db, db_model):
    try:
        db.query(db_model)\
          .filter(db_model.external_id.in_(to_delete))\
          .delete(synchronize_session='fetch')
        db.commit()
    except Exception as e:
        logging.warning('Failed to execute queries: %s' % e)
        yield (f'{len(to_delete)} records', e)
