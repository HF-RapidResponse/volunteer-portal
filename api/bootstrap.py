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

from models import Base, DonationEmail, Initiative, VolunteerEvent, VolunteerRole, Notification, Account, PersonalIdentifier, VerificationToken
from settings import Connections, Session, ENV
from tests.fake_data_utils import generate_fake_volunteer_roles_list, generate_fake_volunteer_events_list, generate_fake_initiatives_list
# from tests.fake_data_utils import generate_fake_volunteer_roles_list, generate_fake_initiatives_list


import logging

logging.basicConfig()
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)


# Create database(s) and tables
for key in Connections:
    # Connect with `echo` so we can see what's being run
    db_url = Connections[key]['url'].replace(f'/{Connections[key]["database"]}', '/postgres')
    engine = create_engine(db_url)
    conn = engine.connect()
    conn.execute("commit")

    # conn.execute(f"SELECT 'DROP DATABASE {Connections[key]['database']}' WHERE EXISTS (SELECT FROM pg_database WHERE datname = '{Connections[key]['database']}')")
    try:
        print(f'\n\nBootstrapping connection {key}')
        conn.execute(f"DROP DATABASE {Connections[key]['database']}")
    except:
        print(f'---- Could not drop database connection {key}')
    finally:
        conn.execute("commit")

    try:
        print('Creating DB')
        conn.execute(f"CREATE DATABASE {Connections[key]['database']}")
    except:
        print(f'---- Could not create database connection {key}')
    finally:
        conn.execute("commit")
    conn.close()

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
    DonationEmail: engines['database'],
    Notification: engines['database'],
    Account: engines['database'],
    PersonalIdentifier: engines['database'],
    VerificationToken: engines['database']
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
