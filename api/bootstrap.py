# Run this script to setup a local database populated with fake data

# Steps:
#   1. Copy config.yml.example to config.yml.
#   2. Make any changes to the "test" and "development" sections for your local database info.
#   3. Run `python bootstrap.py`. It will:
#     Create the databases in "test" and "development" environments.
#     Create all tables needed for the volunteer portal to run.
#     Populate it with fake data.

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from models import Base, Initiative, VolunteerEvent, VolunteerRole, Account, Notification, AccountSettings
from models import UserGroupRelation, Group
from settings import Connections, Session, ENV
from tests.fake_data_utils import generate_fake_volunteer_roles_list, generate_fake_volunteer_events_list, generate_fake_initiatives_list
from tests.fake_data_utils import generate_fake_users_groups_and_relations
from sqlalchemy_utils.functions import drop_database, create_database

from fastapi.testclient import TestClient
from api import app

import logging

logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)

client = TestClient(app)

# Create database(s) and tables
for key in Connections:
    # Connect with `echo` so we can see what's being run
    db_url = Connections[key]['url']
    try:
        drop_database(db_url)
    except Exception as e:
        print(f'---- Could not drop database connection {key} -- {db_url}')

    try:
        create_database(db_url)
    except:
        print(f'---- Could not create database connection {key}  -- {db_url}')

# Connect to all databases
engines = {}
for key in Connections:
    engines[key] = create_engine(Connections[key]['url'])

# Map each table to it's database connection
# (to be used later when using multiple databases)
Session = sessionmaker(binds={
    Initiative: engines['database'],
    VolunteerEvent: engines['database'],
    VolunteerRole: engines['database'],
    Account: engines['database'],
    Notification: engines['database'],
    AccountSettings: engines['database'],
    Group: engines['database'],
    UserGroupRelation: engines['database']
})

# Create all tables
Base.metadata.create_all(engines['database'])


if ENV == 'development':
    # Generate and save fake data to the database
    session = Session()

    session.query(VolunteerRole).delete()
    generate_fake_volunteer_roles_list(session, 5)

    session.query(VolunteerEvent).delete()
    generate_fake_volunteer_events_list(session, 5)

    session.query(Initiative).delete()
    generate_fake_initiatives_list(session, 3, 2, 3)
    session.commit()

    session.query(Group).delete()
    generate_fake_users_groups_and_relations(session, client, user_count=100, group_count=30)
    session.commit()
