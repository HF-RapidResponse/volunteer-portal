from typing import List
from random import seed, randint, choice, shuffle
from uuid import uuid4
from datetime import datetime, timedelta

from faker import Faker # type: ignore

from models import Person, Initiative, VolunteerRole, Priority, VolunteerEvent

fake = Faker()
seed(1000)

def generate_fake_volunteer_role() -> VolunteerRole:
    return VolunteerRole(
        role_uuid = uuid4(),
        role_external_id = fake.name(),
        name  = fake.sentence(),
        details_url = fake.uri(),
        hero_image_url = fake.image_url(),
        priority = Priority.MEDIUM,
        signup_url = fake.uri(),
        point_of_contact = Person(name=fake.name()) if choice([True, False]) else None,
        num_openings = randint(1,10),
        min_time_commitment = randint(1,10),
        max_time_commitment = randint(1,10),
        overview = fake.paragraph(nb_sentences=4),
        benefits = fake.paragraph(nb_sentences=4),
        responsibilites = fake.paragraph(nb_sentences=4),
        qualifications = fake.paragraph(nb_sentences=4)
    )

def generate_fake_volunteer_roles_list(min_number: int = 1, max_number: int = 10) -> List[VolunteerRole]:
    roles = []
    for _ in range(randint(min_number, max_number)):
        roles.append(generate_fake_volunteer_role())
    return roles

def generate_fake_volunteer_event() -> VolunteerEvent:
    start_datetime = datetime.today() + timedelta(days=randint(-10,10))

    return VolunteerEvent(
        event_uuid = uuid4(),
        event_external_id = fake.name(),
        name = fake.sentence(),
        signup_url = fake.uri(),
        details_url = fake.uri(),
        start_datetime = start_datetime,
        end_datetime = start_datetime + timedelta(days=randint(1,10)),
        description = fake.paragraph(nb_sentences=4),
        point_of_contact = Person(name=fake.name()) if choice([True, False]) else None,
    )

def generate_fake_volunteer_events_list(min_number: int = 1, max_number: int = 10) -> List[VolunteerEvent]:
    events = []
    for _ in range(randint(min_number, max_number)):
        events.append(generate_fake_volunteer_event())
    return events

def generate_fake_initiative() -> Initiative:
    roles = generate_fake_volunteer_roles_list(0,2)
    events = generate_fake_volunteer_events_list(0,2)
    items = [*roles, *events]
    shuffle(items)

    return Initiative(
        initiative_uuid = uuid4(),
        initiative_external_id = fake.sentence(),
        name = fake.name(),
        details_url = fake.uri(),
        title = fake.sentence(),
        hero_image_url = fake.uri(),
        content = fake.paragraph(nb_sentences=4),
        roles = roles,
        events = events,
        highlightedItems = items
    )

def generate_fake_initiatives_list(min_number: int = 1, max_number: int = 10) -> List[Initiative]:
    initiatives = []
    for _ in range(randint(min_number, max_number)):
        initiatives.append(generate_fake_initiative())
    return initiatives