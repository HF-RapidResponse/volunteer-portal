import pytest
from datetime import datetime

from sqlalchemy.engine import ResultProxy

from data_sources import Dataset, DataSource, DataSourceType, generate_hf_mysql_db_address, DataSink
from models import VolunteerRole, VolunteerEvent, Initiative, PersonalDonationLinkRequest
from data_source_maps import hf_events, hf_initiatives

hf_mysql = DataSource(data_source_type=DataSourceType.MYSQL,
        address=generate_hf_mysql_db_address('35.188.204.248','airtable_database','no_pii','humanity-forward_hf-db1-mysql_no_pii'))
test_link_db_addr = generate_hf_mysql_db_address('35.188.204.248','airtable_database','no_pii','humanity-forward_hf-db1-mysql_no_pii')

def test_bigquery_data_source():
    # we need to mock this out instead of hitting HF's BigQuery for lots of reasons...but I'm moving fast
    hf_bigquery = DataSource(data_source_type=DataSourceType.BIGQUERY, address='humanity-forward')
    events_dataset = Dataset(data_source = hf_bigquery, dataset_key='AirtableData.events', primary_key='id')

    query_results = events_dataset.get_all_rows()
    assert type(query_results) is ResultProxy

    row = query_results.fetchone()
    assert row
    assert type(row['AirtableData.events_event_id']) is str
    assert type(row['AirtableData.events_start']) is datetime

def test_mysql_data_source():
    # we need to mock this out instead of hitting HF's mysql DB for lots of reasons...but I'm moving fast
    events_dataset = Dataset(data_source = hf_mysql, dataset_key='events', primary_key='id')

    query_results = events_dataset.get_all_rows()
    assert type(query_results) is ResultProxy

    row = query_results.fetchone()
    assert row
    assert type(row['event_id']) is str
    assert type(row['start']) is datetime

def test_ensure_model_key_map_contains_all_keys_and_values():
    good_model_key_map = {
        'event_uuid': None,
        'event_external_id': 'id',
        'name': 'event_id',
        'hero_image_url': 'event_graphics',
        'details_url': None,
        'start_datetime': 'start',
        'end_datetime': 'end',
        'description': 'description',
        'point_of_contact': None,
        'signup_url': 'signup_link'
    }

    _ = Dataset(data_source=hf_mysql, dataset_key='events', primary_key='id', linked_model=VolunteerEvent, model_key_map=good_model_key_map)

def test_ensure_model_key_map_contains_all_keys_error():
    with pytest.raises(AssertionError):
            bad_model_key_map = {
                'event_uuid': None,
                'event_external_id': 'event_id',
                'start_datetime': 'end',
                'end_datetime': 'start',
                'description': 'description',
                'point_of_contact': None,
                'sign_up_link': 'signup_link'
            }

            _ = Dataset(data_source=hf_mysql, dataset_key='events', primary_key='id', linked_model=VolunteerEvent, model_key_map=bad_model_key_map)

def test_get_model_objects():
    events_dataset = Dataset(data_source = hf_mysql, dataset_key='events', primary_key='id', linked_model=VolunteerEvent, model_key_map=hf_events)

    events = events_dataset.get_linked_model_objects()
    assert events

    event = events[-1]
    assert type(event) is VolunteerEvent

def test_get_nested_model_objects():
    initiatives_dataset = Dataset(data_source = hf_mysql, dataset_key='initiatives', primary_key='initiative_name', linked_model=Initiative, model_key_map=hf_initiatives)

    initiatives = initiatives_dataset.get_linked_model_objects()
    assert initiatives

    initiative = initiatives[0]
    assert type(initiative) is Initiative
    assert type(initiative.roles) is list
    assert type(initiative.events) is list
    
    # test is brittle because it relies on unpredictable production data
    if initiative.roles:
        role = initiative.roles[-1]
        assert type(role) is VolunteerRole
    
    if initiative.events:
        event = initiative.events[-1]
        assert type(event) is VolunteerEvent

def test_data_sink_insert():
    donation_link_test_db = DataSink(data_base_type=DataSourceType.MYSQL, address=test_link_db_addr, table='link_requests')
    request = PersonalDonationLinkRequest(email="test@gmail.com", test_db=True)
    donation_link_test_db.insert(request)
