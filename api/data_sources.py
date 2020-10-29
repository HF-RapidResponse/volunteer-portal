from pydantic import BaseModel, validator
from typing import Optional, Union, List, Dict, Any, Generator, Type
from enum import Enum
from uuid import UUID, uuid4
from inspect import signature

from sqlalchemy.sql import select
from sqlalchemy.engine import create_engine, Engine, Connection
from sqlalchemy.schema import Table, MetaData, Column
from google.cloud import secretmanager

from models import VolunteerEvent

secret_client = secretmanager.SecretManagerServiceClient()

class DataSourceType(Enum):
    BIGQUERY = 'bigquery'
    MYSQL = 'mysql'
    # POSTGRES = 'postgres'
    # AIRTABLE = 'airtable'
    # GOOGLE_SHEETS = 'google_sheets'

# should enforce only one DataSource instance for each type + address
# data_sources: Dict[address: DataSource] = {}

class DataSource(BaseModel):
    data_source_uuid: UUID = uuid4()
    address: str
    data_source_type: DataSourceType
    sql_engine: Optional[Engine]
    sql_conn: Optional[Connection]

    # required for non-pydantic SQLAlchemy classes
    class Config:
        arbitrary_types_allowed = True

    def __init__(self, address: str, data_source_type: DataSourceType, **data) -> None:
        super().__init__(address=address, data_source_type=data_source_type, **data)

        #maybe this can/should be addressed with inheritance/another pattern? 
        if self.data_source_type is DataSourceType.BIGQUERY:
            self.sql_engine = create_engine(f'bigquery://{self.address}')
            self.sql_conn = self.sql_engine.connect()
        elif self.data_source_type is DataSourceType.MYSQL:
            self.sql_engine = create_engine(f'mysql+pymysql://{self.address}', pool_recycle=3600)
            self.sql_conn = self.sql_engine.connect()

class Dataset(BaseModel):
    dataset_uuid: UUID = uuid4()
    data_source: DataSource
    dataset_key: str
    mapped_model: Optional[Type]
    model_key_map: Optional[Dict[str, Optional[str]]]
    sql_table: Optional[Table]

    # required for non-pydantic SQLAlchemy classes
    class Config:
        arbitrary_types_allowed = True
    
    def __init__(self, data_source: DataSource, dataset_key: str, **data) -> None:
        super().__init__(data_source=data_source, dataset_key=dataset_key, **data)

        if self.data_source.sql_engine:
            self.sql_table = Table(self.dataset_key, MetaData(bind=self.data_source.sql_engine), autoload=True)
        
        # ensure model_key_map match both mapped_model and the corresponding table
        assert (self.mapped_model and self.model_key_map) or (not self.mapped_model and not self.model_key_map)
        if self.mapped_model and self.model_key_map:
            expected_keys = list(signature(self.mapped_model).parameters)
            assert set(expected_keys) == set(self.model_key_map.keys())

            expected_values = [c.name for c in self.sql_table.c]
            assert all(value in expected_values for value in self.model_key_map.values() if value)
    
    def get_all_rows(self) -> Generator[Any, Any, Any]:
        if self.data_source.sql_engine:            
            results = self.data_source.sql_conn.execute(select([self.sql_table]))
            return results
    
    def get_mapped_model_objects(self) -> Any:
        assert self.mapped_model and self.model_key_map

        models = []

        for row in self.get_all_rows():
            # this currently doesn't work for bigquery due to the odd project.table naming convention...
            params = {k:row[v] for k,v in self.model_key_map.items() if v} 
            models.append(self.mapped_model(**params))

        return(models)

def generate_hf_mysql_db_address(db_ip: str, db_name: str, db_user: str, db_secret_key: str) -> str:
    secret_path = f'projects/humanity-forward/secrets/{db_secret_key}/versions/latest'
    db_pass = secret_client.access_secret_version(request={"name": secret_path}).payload.data.decode('UTF-8')
    return f'{db_user}:{db_pass}@{db_ip}/{db_name}'
