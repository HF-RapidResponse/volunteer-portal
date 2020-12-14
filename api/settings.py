import yaml
import copy
from functools import lru_cache
import os
from sqlalchemy import create_engine # type: ignore
from sqlalchemy.ext.declarative import declarative_base # type: ignore
from sqlalchemy.orm import sessionmaker # type: ignore
from google.cloud import secretmanager  # type: ignore
from models import Initiative, VolunteerEvent, VolunteerRole, PersonalDonationLinkRequest

ENV = os.environ.get('ENV') if os.environ.get('ENV') else "development"
secret_client = secretmanager.SecretManagerServiceClient()

# Create a dict object with URLs for all DB connection strings
@lru_cache()
def read_config():
    with open("config.yaml", 'r') as f:
        config = yaml.load(f, Loader=yaml.FullLoader)[ENV]
    return config
Config = read_config()

# Generate Database URLs based on the DB connection information
def generate_hf_mysql_db_address(connection) -> str:
    db_secret_key = connection['password']
    secret_path = f'projects/humanity-forward/secrets/{db_secret_key}/versions/latest'
    db_pass = secret_client.access_secret_version(request={"name": secret_path}).payload.data.decode('UTF-8')
    return f'{connection["adapter"]}://{connection["user"]}:{db_pass}@{connection["host"]}/{connection["database"]}'

def generate_db_url(connection) -> str:
    return f'{connection["adapter"]}://{connection["user"]}:{connection["password"]}@{connection["host"]}/{connection["database"]}'
db_url_generators = {
    "secret_generator": generate_hf_mysql_db_address,
    "db_url_generator" : generate_db_url
}

Connection = generate_db_url(Config['database'])

# Create session connection to the database connections
engine = create_engine(Connection)
Session = sessionmaker(binds={
    Initiative: engine,
    VolunteerEvent: engine,
    VolunteerRole: engine,
#    PersonalDonationLinkRequest: engine,
})
