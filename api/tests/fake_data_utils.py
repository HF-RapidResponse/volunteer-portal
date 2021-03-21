from typing import List
from random import seed, randint, choice, shuffle
from datetime import datetime, timedelta

from faker import Faker # type: ignore
from faker.providers import barcode #type: ignore

from models import NestedInitiative, Initiative, Person, Priority, RoleType, VolunteerRole, VolunteerEvent

fake = Faker()
fake.add_provider(barcode)
seed(1000)

def generate_fake_volunteer_role() -> VolunteerRole:
    post_datetime = datetime.today() + timedelta(days=randint(-10,10))
    return VolunteerRole(
        external_id = fake.ean(),
        role_name = fake.sentence(),
        hero_image_urls = ([ { 'url': fake.image_url() }] if choice([True, False]) else []),
        signup_url = fake.uri(),
        details_url = fake.uri(),
        priority = Priority.MEDIUM,
        team = [fake.ean()],
        team_lead_ids = ([fake.ean()] if choice([True, False]) else []),
        num_openings = randint(1,10),
        min_time_commitment = randint(1,10),
        max_time_commitment = randint(1,10),
        overview = fake.paragraph(nb_sentences=4),
        benefits = fake.paragraph(nb_sentences=4),
        responsibilities = fake.paragraph(nb_sentences=4),
        qualifications = fake.paragraph(nb_sentences=4),
        role_type = (RoleType.REQUIRES_APPLICATION if choice([True, False]) else RoleType.OPEN_TO_ALL),
        airtable_last_modified = post_datetime - timedelta(days=randint(10,12)),
        updated_at = post_datetime - timedelta(days=randint(6,8)),
        is_deleted = False,
    )

def generate_fake_volunteer_roles_list(session, count: int = 1) -> List[VolunteerRole]:
    roles = []
    for _ in range(count):
        role = generate_fake_volunteer_role()
        session.add(role)
        roles.append(role)
    return roles

def generate_fake_volunteer_event() -> VolunteerEvent:
    start_datetime = datetime.today() + timedelta(days=randint(-10,10))

    return VolunteerEvent(
        external_id = fake.ean(),
        event_name = fake.sentence(),
        signup_url = fake.uri(),
        hero_image_urls = ([ { 'url': fake.image_url() }] if choice([True, False]) else []),
        start_datetime = start_datetime,
        end_datetime = start_datetime + timedelta(days=randint(1,10)),
        description = fake.paragraph(nb_sentences=4),
        airtable_last_modified = start_datetime - timedelta(days=randint(10,12)),
        updated_at = start_datetime - timedelta(days=randint(6,8)),
        is_deleted = False,
    )

def generate_fake_volunteer_events_list(session, count: int = 1) -> List[VolunteerEvent]:
    events = []
    for _ in range(count):
        event = generate_fake_volunteer_event()
        session.add(event)
        events.append(event)
    return events

def generate_fake_initiative(session, roles_count: int = 1, events_count: int = 1, order_num: int = 1) -> NestedInitiative:
    roles = generate_fake_volunteer_roles_list(session, roles_count)
    role_ids = []
    for role in roles:
        role_ids.append(role.external_id)

    events = generate_fake_volunteer_events_list(session, events_count)
    event_ids = []
    for event in events:
        event_ids.append(event.external_id)

    items = [*role_ids, *event_ids]
    shuffle(items)

    post_datetime = datetime.today() + timedelta(days=randint(-10,10))
    return NestedInitiative(
        external_id = fake.ean(),
        initiative_name = fake.name(),
        details_url = fake.uri(),
        order = order_num,
        hero_image_urls = ([ { 'url': fake.image_url() }] if choice([True, False]) else []),
        content = fake.paragraph(nb_sentences=4),
        role_ids = role_ids,
        event_ids = event_ids,
        airtable_last_modified = post_datetime - timedelta(days=randint(10,12)),
        updated_at = post_datetime - timedelta(days=randint(6,8)),
        is_deleted = False,
    )

def generate_fake_initiatives_list(session, count: int = 1, roles_count: int = 2, events_count: int = 2) -> List[NestedInitiative]:
    initiatives = []
    for i in range(count):
        initiative = generate_fake_initiative(session, roles_count, events_count, i + 1)
        session.add(initiative)
        initiatives.append(initiative)
    return initiatives
