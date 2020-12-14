# Run this script to setup a local database populated with fake data

# Steps:
#   1. Copy config.yml.example to config.yml.
#   2. Make any changes to the "test" and "development" sections for your local database info.
#   3. Run `python bootstrap.py`. It will:
#     Create the databases in "test" and "development" environments.
#     Create all tables needed for the volunteer portal to run.
#     Populate it with fake data.

from sqlalchemy import create_engine # type: ignore
from sqlalchemy.orm import sessionmaker # type: ignore
from sqlalchemy_utils import database_exists, create_database, drop_database # type: ignore

from models import Base, Initiative, VolunteerEvent, VolunteerRole, PersonalDonationLinkRequest
from settings import Connections, Session, ENV
from tests.fake_data_utils import generate_fake_volunteer_roles_list, generate_fake_volunteer_events_list, generate_fake_initiatives_list

import logging

logging.basicConfig()
# Set to logging.INFO to see full SQL command set
logging.getLogger('sqlalchemy.engine').setLevel(logging.WARNING)
print ("Setting up DB and tables...")

# Create database(s) and tables
db_url = Connections['url']
engine = create_engine(db_url)
print(engine.url)
drop_database(engine.url)
create_database(engine.url)
conn = engine.connect()
conn.execute("commit")

# Connect to all databases

engines = {'database': create_engine(Connections['url'])}

# Map each table to it's database connection
# (to be used later when using multiple databases)
Session = sessionmaker(binds={
    Initiative: engines['database'],
    VolunteerEvent: engines['database'],
    VolunteerRole: engines['database'],
    PersonalDonationLinkRequest: engines['database'],
    # Todo: Map other tables to connections
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
print("Done.")
