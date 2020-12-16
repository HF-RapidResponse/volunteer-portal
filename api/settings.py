import yaml
<<<<<<< HEAD
from functools import lru_cache
import os
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from models import Initiative, VolunteerEvent, VolunteerRole

ENV = os.environ.get('ENV') if os.environ.get('ENV') else "development"
=======
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
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100

# Create a dict object with URLs for all DB connection strings
@lru_cache()
def read_config():
    with open("config.yaml", 'r') as f:
        config = yaml.load(f, Loader=yaml.FullLoader)[ENV]
    return config
Config = read_config()


# Generate Database URLs based on the DB connection information
def generate_hf_mysql_db_address(connection) -> str:
<<<<<<< HEAD
=======
    db_secret_key = connection['password']
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
    secret_path = f'projects/humanity-forward/secrets/{db_secret_key}/versions/latest'
    db_pass = secret_client.access_secret_version(request={"name": secret_path}).payload.data.decode('UTF-8')
    return f'{connection["adapter"]}://{connection["user"]}:{db_pass}@{connection["host"]}/{connection["database"]}'

def generate_db_url(connection) -> str:
    return f'{connection["adapter"]}://{connection["user"]}:{connection["password"]}@{connection["host"]}/{connection["database"]}'
db_url_generators = {
    "secret_generator": generate_hf_mysql_db_address,
    "db_url_generator" : generate_db_url
}

<<<<<<< HEAD

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
=======
# Create a dict of all connection strings
def create_connections(generators, config):
    connections = copy.deepcopy(config)
    connections['url'] = generators[config['generator']](config)
    return connections
Connections = create_connections(db_url_generators, Config)

# Create session connection to the database connections
engine = create_engine(Connections['url'])
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
Session = sessionmaker(binds={
    Initiative: engine,
    VolunteerEvent: engine,
    VolunteerRole: engine,
<<<<<<< HEAD
=======
#    PersonalDonationLinkRequest: engine,
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
})
