from typing import List, Optional

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from models import Initiative, VolunteerRole, VolunteerEvent
from fake_data_utils import generate_fake_volunteer_roles_list, generate_fake_initiatives_list, generate_fake_volunteer_events_list \
    , generate_fake_volunteer_role, generate_fake_volunteer_event, generate_fake_initiative
from data_sources import Dataset, DataSource, DataSourceType, generate_hf_mysql_db_address
from data_source_maps import hf_events, hf_volunteer_openings, hf_initiatives
import logging

logging.basicConfig(level=logging.DEBUG)

app = FastAPI()

origins = ['*']

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

hf_db = DataSource(data_source_type=DataSourceType.MYSQL,
        address=generate_hf_mysql_db_address('35.188.204.248','airtable_database','no_pii','humanity-forward_hf-db1-mysql_no_pii'))
initiatives_dataset = Dataset(data_source = hf_db, dataset_key='initiatives', primary_key='id', linked_model=Initiative, model_key_map=hf_initiatives)
events_dataset = Dataset(data_source = hf_db, dataset_key='events', primary_key='id', linked_model=VolunteerEvent, model_key_map=hf_events)
roles_dataset = Dataset(data_source = hf_db, dataset_key='volunteer_openings', primary_key='id', linked_model=VolunteerRole, model_key_map=hf_volunteer_openings)

@app.get("/", response_model=str)
def root() -> str:
    return "Hello from the Humanity Forward Volunteer Portal Dev Team"

@app.get("/volunteer_roles/", response_model=List[VolunteerRole])
def get_all_volunteer_roles(fake_data: bool = False) -> List[VolunteerRole]:
    return roles_dataset.get_linked_model_objects() if not fake_data else generate_fake_volunteer_roles_list()

@app.get("/volunteer_roles/{role_external_id}", response_model=VolunteerRole)
def get_volunteer_role_by_external_id(role_external_id, fake_data: bool = False) -> Optional[VolunteerRole]:
    return roles_dataset.get_linked_model_object_for_primary_key(role_external_id) if not fake_data else generate_fake_volunteer_role()

@app.get("/volunteer_events/", response_model=List[VolunteerEvent])
def get_all_volunteer_events(fake_data: bool = False) -> List[VolunteerEvent]:
    return events_dataset.get_linked_model_objects() if not fake_data else generate_fake_volunteer_events_list()

@app.get("/volunteer_events/{event_external_id}", response_model=VolunteerEvent)
def get_volunteer_event_by_external_id(event_external_id, fake_data: bool = False) -> Optional[VolunteerEvent]:
    return events_dataset.get_linked_model_object_for_primary_key(event_external_id) if not fake_data else generate_fake_volunteer_event()

@app.get("/initiatives/", response_model=List[Initiative])
def get_all_initiatives(fake_data: bool = False) -> List[Initiative]:
    return initiatives_dataset.get_linked_model_objects() if not fake_data else generate_fake_initiatives_list()

@app.get("/initiatives/{initiative_external_id}", response_model=Initiative)
def get_initiative_by_external_id(initiative_external_id, fake_data: bool = False) -> List[Initiative]:
    return initiatives_dataset.get_linked_model_object_for_primary_key(initiative_external_id) if not fake_data else generate_fake_initiative() # type: ignore
