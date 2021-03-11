from typing import List
from random import seed, randint, choice, shuffle
from datetime import datetime, timedelta

from faker import Faker  # type: ignore
from faker.providers import barcode, job, address  # type: ignore

# from models import Person, Initiative, VolunteerRole, Priority, VolunteerEvent
from models import Initiative, Person, Priority, RoleType, VolunteerRole, VolunteerEvent, DonationEmail
from models import Account

fake = Faker()
fake.add_provider(barcode)
seed(1000)


def generate_fake_volunteer_role() -> VolunteerRole:
    post_datetime = datetime.today() + timedelta(days=randint(-10, 10))
    return VolunteerRole(
        external_id=fake.ean(),
        role_name=fake.sentence(),
        hero_image_urls=([{'url': fake.image_url()}]
                         if choice([True, False]) else []),
        signup_url=fake.uri(),
        details_url=fake.uri(),
        priority=Priority.MEDIUM,
        team=[fake.ean()],
        team_lead_ids=([fake.ean()] if choice([True, False]) else []),
        num_openings=randint(1, 10),
        min_time_commitment=randint(1, 10),
        max_time_commitment=randint(1, 10),
        overview=fake.paragraph(nb_sentences=4),
        benefits=fake.paragraph(nb_sentences=4),
        responsibilities=fake.paragraph(nb_sentences=4),
        qualifications=fake.paragraph(nb_sentences=4),
        role_type=(RoleType.REQUIRES_APPLICATION if choice(
            [True, False]) else RoleType.OPEN_TO_ALL),
        airtable_last_modified=post_datetime - timedelta(days=randint(10, 12)),
        updated_at=post_datetime - timedelta(days=randint(6, 8)),
        is_deleted=False,
    )


def generate_fake_volunteer_roles_list(session, count: int = 1) -> List[VolunteerRole]:
    roles = []
    for _ in range(count):
        role = generate_fake_volunteer_role()
        session.add(role)
        roles.append(role)
    return roles


def generate_fake_volunteer_event() -> VolunteerEvent:
    start_datetime = datetime.today() + timedelta(days=randint(-10, 10))

    return VolunteerEvent(
        external_id=fake.ean(),
        event_name=fake.sentence(),
        signup_url=fake.uri(),
        hero_image_urls=([{'url': fake.image_url()}]
                         if choice([True, False]) else []),
        start_datetime=start_datetime,
        end_datetime=start_datetime + timedelta(days=randint(1, 10)),
        description=fake.paragraph(nb_sentences=4),
        airtable_last_modified=start_datetime -
        timedelta(days=randint(10, 12)),
        updated_at=start_datetime - timedelta(days=randint(6, 8)),
        is_deleted=False,
    )


def generate_fake_volunteer_events_list(session, count: int = 1) -> List[VolunteerEvent]:
    events = []
    for _ in range(count):
        event = generate_fake_volunteer_event()
        session.add(event)
        events.append(event)
    return events


def generate_fake_initiative(session, roles_count: int = 1, events_count: int = 1, order_num: int = 1) -> Initiative:
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

    post_datetime = datetime.today() + timedelta(days=randint(-10, 10))
    return Initiative(
        external_id=fake.ean(),
        initiative_name=fake.name(),
        details_url=fake.uri(),
        order=order_num,
        hero_image_urls=([{'url': fake.image_url()}]
                         if choice([True, False]) else []),
        content=fake.paragraph(nb_sentences=4),
        role_ids=role_ids,
        event_ids=event_ids,
        airtable_last_modified=post_datetime - timedelta(days=randint(10, 12)),
        updated_at=post_datetime - timedelta(days=randint(6, 8)),
        is_deleted=False,
    )


def generate_fake_initiatives_list(session, count: int = 1, roles_count: int = 2, events_count: int = 2) -> List[Initiative]:
    initiatives = []
    for i in range(count):
        initiative = generate_fake_initiative(
            session, roles_count, events_count, i + 1)
        session.add(initiative)
        initiatives.append(initiative)
    return initiatives


def generate_fake_donation_email():
    fake_donation_email = DonationEmail(email=fake.email())
    return fake_donation_email

def get_fake_email():
    # dash isn't valid in the domain part of an email according to one of our checkers.
    return fake.unique.email().replace("-", "")

def generate_fake_account():
    return Account(
        email=get_fake_email(),
        username=fake.name().replace(" ", ""),
        first_name=fake.first_name(),
        last_name=fake.last_name(),
        password=fake.password(),
        oauth=fake.password(),
        # TODO simple http server to act as testing object storage
        profile_pic=fake.url(),
        city=fake.city(),
        state=fake.state(),
        roles=[fake.job() for i in range(randint(0,2))],

    )
