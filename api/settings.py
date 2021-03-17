from typing import Dict, List
import yaml
from functools import lru_cache
import os
import logging
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from google.cloud import secretmanager  # type: ignore
from models import Initiative, VolunteerEvent, VolunteerRole, DonationEmail, Account, Notification, AccountSettings

ENV = os.environ.get('ENV') if os.environ.get('ENV') else "development"

try:
    secret_client = secretmanager.SecretManagerServiceClient()
except Exception as e:
    if ENV == 'development':
        logging.warning(
            'Unable to connect to secret store, falling back to config.yaml')
    else:
        raise RuntimeError('Failed to connect to secret store') from e


def get_secret_for_key(key):
    secret_path = f'projects/humanity-forward/secrets/{key}/versions/latest'
    return secret_client.access_secret_version(request={"name": secret_path}).payload.data.decode('UTF-8')


def import_auth_credentials_from_secret_store(config):
    for auth_key in config['auth']:
        if auth_key == 'import_auth_credentials_from_secret_store':
            pass
        else:
            for credential_key in config['auth'][auth_key]:
                config['auth'][auth_key][credential_key] = get_secret_for_key(
                    config['auth'][auth_key][credential_key])

    return config

# Create a dict object with all configurations


@lru_cache()
def read_config():
    with open("config.yaml", 'r') as f:
        config = yaml.load(f, Loader=yaml.FullLoader)[ENV]
    if not ('import_auth_credentials_from_secret_store' in config['auth'] and not config['auth']['import_auth_credentials_from_secret_store']):
        config = import_auth_credentials_from_secret_store(config)

    config['notifications']['sendgrid_api_key'] = get_secret_for_key(
        config['notifications']['sendgrid_api_key'])
    config['notifications']['twilio_sid'] = get_secret_for_key(
        config['notifications']['twilio_sid'])
    config['notifications']['twilio_auth_token'] = get_secret_for_key(
        config['notifications']['twilio_auth_token'])

    return config


Config = read_config()

# Generate Database URLs based on the DB connection information


def generate_hf_secret_db_address(connection) -> str:
    secret_client = secretmanager.SecretManagerServiceClient()
    secret_path = f'projects/humanity-forward/secrets/{connection["password"]}/versions/latest'
    db_pass = secret_client.access_secret_version(
        request={"name": secret_path}).payload.data.decode('UTF-8')
    return f'{connection["adapter"]}://{connection["user"]}:{db_pass}@{connection["host"]}/{connection["database"]}'


def generate_db_url(connection: Dict) -> str:
    return f'{connection["adapter"]}://{connection["user"]}:{connection["password"]}@{connection["host"]}/{connection["database"]}'


db_url_generators = {
    "secret_generator": generate_hf_secret_db_address,
    "db_url_generator": generate_db_url
}


# Create a dict of all connection strings
def create_connections(generators, config):
    connections = {}
    for key in config:
        connections[key] = config[key]
        connections[key]['url'] = generators[config[key]
                                             ['generator']](config[key])
    return connections


Connections = create_connections(db_url_generators, Config['databases'])


# Create session connection to the database connections
engine = create_engine(Connections['database']['url'])
Session = sessionmaker(binds={
    Initiative: engine,
    VolunteerEvent: engine,
    VolunteerRole: engine,
    DonationEmail: engine,
    Account: engine,
    AccountSettings: engine,
    Notification: engine,
})

# Api Dependency


def get_db():
    try:
        db = Session()
        yield db
    finally:
        db.close()
