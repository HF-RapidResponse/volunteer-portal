# Run this script to setup a local database populated with fake data

# Steps:
#   1. Copy config.yml.example to config.yml.
#   2. Make any changes to the "test" and "development" sections for your local database info.
#   3. Run `python bootstrap.py`. It will:
#     Create the databases in "test" and "development" environments.
#     Create all tables needed for the volunteer portal to run.
#     Populate it with fake data.

import yaml
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from models import Base, Initiative, VolunteerEvent, VolunteerRole
from settings import Connections, Session
from tests.fake_data_utils import generate_fake_volunteer_roles_list
# from tests.fake_data_utils import generate_fake_volunteer_roles_list, generate_fake_initiatives_list

# Create database(s) and tables
for key in Connections:
    print(f'Bootstrapping connection {key}')

    # Connect with `echo` so we can see what's being run
    db_url = Connections[key]['url'].replace(f'/{Connections[key]["database"]}', '/postgres')
    engine = create_engine(db_url, echo=True)
    conn = engine.connect()
    conn.execute("commit")
    conn.execute(f"SELECT 'CREATE DATABASE {Connections[key]['database']}' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '{Connections[key]['database']}')")
    conn.close()

# Connect to all databases
engines = {}
for key in Connections:
    engines[key] = create_engine(Connections[key]['url'], echo=True)

Session = sessionmaker(binds={
    Initiative: engines['database'],
    VolunteerEvent: engines['database'],
    VolunteerRole: engines['database']
    # Todo: Map other tables to connections
})

Base.metadata.create_all(engines['database'])

# Generate fake data.
# initiatives = generate_fake_initiatives_list(3)
# session.add_all(initiatives)


session = Session()
volunteer_roles = generate_fake_volunteer_roles_list(10, 10)
print(f'Create volunteer_roles: {volunteer_roles}')
session.add_all(volunteer_roles)
