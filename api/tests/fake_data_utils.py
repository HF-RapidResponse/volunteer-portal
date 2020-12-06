from typing import List
from random import seed, randint, choice, shuffle
from datetime import datetime, timedelta

from faker import Faker # type: ignore

# from models import Person, Initiative, VolunteerRole, Priority, VolunteerEvent
from models import Initiative, Person, Priority, RoleType, VolunteerRole, VolunteerEvent

fake = Faker()
seed(1000)

def generate_fake_volunteer_role() -> VolunteerRole:
    return VolunteerRole(
        role_external_id = fake.name(),
        name = fake.sentence(),
        details_url = fake.uri(),
        hero_image_urls = ([ { 'url': fake.image_url() }] if choice([True, False]) else []),
        priority = Priority.MEDIUM,
        signup_url = fake.uri(),
        point_of_contact_name = (fake.name() if choice([True, False]) else None),
        num_openings = randint(1,10),
        min_time_commitment = randint(1,10),
        max_time_commitment = randint(1,10),
        overview = fake.paragraph(nb_sentences=4),
        benefits = fake.paragraph(nb_sentences=4),
        responsibilites = fake.paragraph(nb_sentences=4),
        qualifications = fake.paragraph(nb_sentences=4),
        role_type = (RoleType.REQUIRES_APPLICATION if choice([True, False]) else RoleType.OPEN_TO_ALL)
    )

def generate_fake_volunteer_roles_list(session, count: int = 1) -> List[VolunteerRole]:
    roles = []
    for _ in range(count):
        role = generate_fake_volunteer_role()
        session.add(role)
        roles.append(role)
    return roles

def generate_fake_volunteer_event() -> VolunteerEvent:
    start_datetime = datetime.today() + timedelta(days=randint(-10,10),
                                                  minutes=randint(-100,100))

    return VolunteerEvent(
        event_external_id = fake.name(),
        name = fake.sentence(),
        signup_url = fake.uri(),
        details_url = fake.uri(),
        hero_image_urls = ([ { 'url': fake.image_url() }] if choice([True, False]) else []),
        start_datetime = start_datetime,
        end_datetime = start_datetime + timedelta(days=randint(1,10)),
        description = fake.paragraph(nb_sentences=4),
        point_of_contact_name = fake.name() if choice([True, False]) else None
    )

def generate_fake_volunteer_events_list(session, count: int = 1) -> List[VolunteerEvent]:
    events = []
    for _ in range(count):
        event = generate_fake_volunteer_event()
        session.add(event)
        events.append(event)
    return events

def generate_fake_initiative(session, roles_count: int = 1, events_count: int = 1) -> Initiative:
    roles = generate_fake_volunteer_roles_list(session, roles_count)
    role_ids = []
    for role in roles:
        role_ids.append(role.role_external_id)

    events = generate_fake_volunteer_events_list(session, events_count)
    event_ids = []
    for event in events:
        event_ids.append(event.event_external_id)

    items = [*role_ids, *event_ids]
    shuffle(items)

    return Initiative(
        initiative_external_id = fake.sentence(),
        name = fake.name(),
        details_url = fake.uri(),
        hero_image_urls = ([ { 'url': fake.image_url() }] if choice([True, False]) else []),
        content = fake.paragraph(nb_sentences=4),
        role_ids = role_ids,
        event_ids = event_ids,
        # highlightedItems = items
    )

def generate_fake_initiatives_list(session, count: int = 1, roles_count: int = 2, events_count: int = 2) -> List[Initiative]:
    initiatives = []
    for _ in range(count):
        initiative = generate_fake_initiative(session, roles_count, events_count)
        session.add(initiative)
        initiatives.append(initiative)
    return initiatives
