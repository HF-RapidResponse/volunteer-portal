from typing import List
from random import seed, randint, choice, shuffle, sample
from datetime import datetime, timedelta

from faker import Faker  # type: ignore
from faker.providers import barcode, job, address  # type: ignore

from models import (NestedInitiative, Initiative, Person, Priority,
                    RoleType, VolunteerRole, VolunteerEvent, Account, Group, UserGroupRelation,
                    Relationship)

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

    post_datetime = datetime.today() + timedelta(days=randint(-10, 10))
    return NestedInitiative(
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


def generate_fake_initiatives_list(session, count: int = 1, roles_count: int = 2, events_count: int = 2) -> List[NestedInitiative]:
    initiatives = []
    for i in range(count):
        initiative = generate_fake_initiative(
            session, roles_count, events_count, i + 1)
        session.add(initiative)
        initiatives.append(initiative)
    return initiatives


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
        zip_code=fake.postcode(),
        roles=[fake.job() for i in range(randint(0, 2))],
        is_verified=True
    )

def create_fake_account(client):
    account = {'email': get_fake_email(),
               'username': fake.name().replace(" ", ""),
               'first_name': fake.first_name(),
               'last_name': fake.last_name(),
               'password': "test.1234",
               'oauth': None,
               'profile_pic': fake.url(),
               'city': fake.city(),
               'state': fake.state(),
               'zip_code': fake.postcode(),
               'roles': [fake.job() for i in range(randint(0, 2))],
               'is_verified': True}
    response = client.post('api/accounts/', json=account).json()
    return response

def create_fake_accounts(client, count):
    accounts = []
    for _ in range(count):
        accounts.append(create_fake_account(client))

def generate_fake_group(unique=0) -> Group:
    social_medias = ["Facebook", "twitter", "discord"]
    name = fake.state() + " Yang Gang " + (str(unique) if unique else "")
    return Group(
        group_name=name,
        location_description=fake.state(),
        description=fake.paragraph(nb_sentences=4),
        zip_code=fake.postcode(),
        approved_public=True,
        social_media_links={choice(social_medias): fake.uri() for i in range(randint(0, 3))},
    )

def generate_fake_groups_list(session, count) -> List[Group]:
    groups = []
    for i in range(count):
        group = generate_fake_group(i)
        session.add(group)
        groups.append(group)
    return groups

def create_user_group_relationship(user_object, group_object, relationship="Member"):
    return UserGroupRelation(
        user_id=user_object.uuid,
        group_id=group_object.uuid,
        relationship=Relationship(relationship))

def generate_fake_users_groups_and_relations(session, client, user_count, group_count):
    # generate n groups and m users, create ~2m admin (1 or 2 per group)
    # some admin should be admin to multiple groups

    create_fake_accounts(client, user_count)
    generate_fake_groups_list(session, group_count)

    # get users accounts and groups from db so that uuids are populated
    users = session.query(Account).all()
    groups = session.query(Group).all()
    # make a single admin per group
    admin_list = []
    for i, g in enumerate(groups):
        admin = users[i]
        admin_list.append(admin)
        rel = create_user_group_relationship(admin, g, 'Admin')
        session.add(rel)

    # make half of those admins admin of other groups & members of those groups
    for i, admin in enumerate(admin_list[:len(admin_list) // 2]):
        g = groups[-1 * i]
        rel = create_user_group_relationship(admin, g, 'Admin')
        session.add(rel)
        rel = create_user_group_relationship(admin, g, 'Member')
        session.add(rel)

    # make each user a member of 1-5 groups
    assert len(groups) > 5, "Must create more than 5 groups"
    for user in users:
        group_selection = sample(groups, randint(1, 5))
        for g in group_selection:
            rel = create_user_group_relationship(user, g, 'Member')
            session.add(rel)
