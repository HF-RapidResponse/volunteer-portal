from typing import List
from fastapi import FastAPI
from faker import Faker # type: ignore
from random import seed, randint, choice

from models import *

app = FastAPI()

# this is just for creating fake data for demonstrative purposes
fake = Faker()
seed(1)

@app.get("/")
async def root() -> str:
    return "Hello Humanity Forward Vol-Portal Dev Team"

@app.get("/volunteer_roles/", response_model=List[VolunteerRole])
async def get_all_volunteer_roles() -> List[VolunteerRole]:
    # create some fake volunteer roles
    roles = []
    for num_roles in range(randint(1,10)):
        roles.append(VolunteerRole(
            position_id = fake.sentence(),
            hero_image_url = fake.image_url(),
            priority = Priority.MEDIUM,
            signup_url = fake.uri(),
            hrff_team_lead = Person(name=fake.name()) if choice([True, False]) else None,
            num_openings = randint(1,10),
            min_weekly_time_commitment = randint(1,10),
            max_weekly_time_commitment = randint(1,10),
            overview = fake.paragraph(nb_sentences=4),
            what_you_will_learn = fake.paragraph(nb_sentences=4),
            responsibilites = fake.paragraph(nb_sentences=4),
            qualifications = fake.paragraph(nb_sentences=4)
        ))
    return roles

@app.post("/volunteer_roles/", response_model=VolunteerRole)
async def create_volunteer_role(role: VolunteerRole) -> VolunteerRole:
    return "role"
