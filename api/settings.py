import yaml
from functools import lru_cache
import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from models import Initiative, VolunteerEvent, VolunteerRole


def placeholder_image() -> str:
    return 'https://actblue-indigo-uploads.s3.amazonaws.com/uploads/list-editor/brandings/65454/header/image_url/f7edc334-2217-43b9-b707-5b7eaed92c1b-logo_stacked.svg'

# Create a dict object with URLs for all DB connection strings
@lru_cache()
def read_config():
    with open("config.yaml", 'r') as f:
        config = yaml.load(f, Loader=yaml.FullLoader)[os.environ.get('ENV')]
    return config
Config = read_config()


# Generate Database URLs based on the DB connection information
def generate_hf_mysql_db_address(connection) -> str:
    secret_path = f'projects/humanity-forward/secrets/{db_secret_key}/versions/latest'
    db_pass = secret_client.access_secret_version(request={"name": secret_path}).payload.data.decode('UTF-8')
    return f'{connection["adapter"]}://{connection["user"]}:{db_pass}@{connection["host"]}/{connection["database"]}'

def generate_db_url(connection) -> str:
    return f'{connection["adapter"]}://{connection["user"]}:{connection["password"]}@{connection["host"]}/{connection["database"]}'
db_url_generators = {
    "secret_generator": generate_hf_mysql_db_address,
    "db_url_generator" : generate_db_url
}


# Create a dict of all connection strings
def create_connections(generators, config):
    connections = {}
    for key in config:
        connections[key] = config[key]
        connections[key]['url'] = generators[config[key]['generator']](config[key])
    return connections
Connections = create_connections(db_url_generators, Config)


# Create session connection to the database connections
engine = create_engine(Connections['database']['url'])
Session = sessionmaker(binds={
    Initiative: engine,
    VolunteerEvent: engine,
    VolunteerRole: engine,
})
