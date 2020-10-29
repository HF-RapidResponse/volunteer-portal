from typing import List

from fastapi import FastAPI

from models import Initiative, VolunteerRole, VolunteerEvent
from fake_data_utils import generate_fake_volunteer_roles_list, generate_fake_initiatives_list, generate_fake_volunteer_events_list
from data_sources import Dataset, DataSource, DataSourceType, generate_hf_mysql_db_address
from data_source_maps import hf_events, hf_volunteer_openings

app = FastAPI()

hf_db = DataSource(data_source_type=DataSourceType.MYSQL,
        address=generate_hf_mysql_db_address('35.188.204.248','airtable_database','no_pii','humanity-forward_hf-db1-mysql_no_pii'))
events_dataset = Dataset(data_source = hf_db, dataset_key='events', mapped_model=VolunteerEvent, model_key_map=hf_events)
roles_dataset = Dataset(data_source = hf_db, dataset_key='volunteer_openings', mapped_model=VolunteerRole, model_key_map=hf_volunteer_openings)

@app.get("/")
def root() -> str:
    return "Hello Humanity Forward Vol-Portal Dev Team"

@app.get("/volunteer_roles/", response_model=List[VolunteerRole])
def get_all_volunteer_roles(real_values: bool = False) -> List[VolunteerRole]:
    return roles_dataset.get_mapped_model_objects() if real_values else generate_fake_volunteer_roles_list()

@app.post("/volunteer_roles/", response_model=VolunteerRole)
def create_volunteer_role(role: VolunteerRole) -> VolunteerRole:
    return role

@app.get("/volunteer_events/", response_model=List[VolunteerEvent])
def get_all_volunteer_events(real_values: bool = False) -> List[VolunteerRole]:
    return events_dataset.get_mapped_model_objects() if real_values else generate_fake_volunteer_events_list()

@app.get("/initiatives/", response_model=List[Initiative])
def get_all_initiatives() -> List[Initiative]:
    return generate_fake_initiatives_list()

