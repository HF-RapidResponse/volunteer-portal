from pydantic import BaseModel
from typing import Optional, Union, List, Dict, Any, Type, Tuple, Callable
from enum import Enum
from uuid import UUID, uuid4
from inspect import signature
import logging


from sqlalchemy.sql import select  # type: ignore
from sqlalchemy.engine import create_engine, Engine, Connection, ResultProxy, RowProxy  # type: ignore
from sqlalchemy.schema import Table, MetaData  # type: ignore
from google.cloud import secretmanager  # type: ignore

logger = logging.getLogger(__name__)
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

    # required for non-pydantic SQLAlchemy classes
    class Config:
        arbitrary_types_allowed = True

    def __init__(self, address: str, data_source_type: DataSourceType, **data) -> None:
        super().__init__(address=address, data_source_type=data_source_type, **data)

        #maybe this can/should be addressed with inheritance/another pattern? 
        if self.data_source_type is DataSourceType.BIGQUERY:
            self.sql_engine = create_engine(f'bigquery://{self.address}')
        elif self.data_source_type is DataSourceType.MYSQL:
            self.sql_engine = create_engine(f'mysql+pymysql://{self.address}', pool_recycle=300)

class DataSink(BaseModel):
    data_sink_uuid: UUID = uuid4()
    address: str
    data_base_type: DataSourceType
    sql_engine: Engine = None
    sql_table: Table = None

    # required for non-pydantic SQLAlchemy classes
    class Config:
        arbitrary_types_allowed = True

    def __init__(self, address: str, table: str, data_base_type: DataSourceType, **data) -> None:
        super().__init__(address=address, data_base_type=data_base_type, **data)
        self.sql_engine = create_engine(f'mysql+pymysql://{self.address}', pool_recycle=3600)
        self.sql_table = Table(table, MetaData(bind=self.sql_engine), autoload=True)

    def insert(self, row: Any):
        self.sql_engine.execute(self.sql_table.insert(), row.dict())
        
datasets: Dict[Tuple[Type[DataSource], str, Optional[Type]], 'Dataset'] = {}

class Dataset(BaseModel):
    dataset_uuid: UUID = uuid4()
    data_source: DataSource
    dataset_key: str
    primary_key: str
    linked_model: Optional[Type]
    model_key_map: Optional[Dict[str, Union[Optional[str],Optional[Dict[str,Callable]]]]]
    sql_table: Optional[Table] 

    # required for non-pydantic SQLAlchemy classes
    class Config:
        arbitrary_types_allowed = True
    
    # in the future should enforce not creating duplicate instances
    # def __new__(cls, data_source: DataSource, dataset_key: str, *args, **kwargs) -> 'Dataset':
    #     hash_key = tuple(DataSource, dataset_key, kwargs['mapped_model'] if kwargs['mapped_model'] else None)

    #     if hash_key in datasets.keys():
    #         return datasets[hash_key]
    #     else:
    #         dataset = 
    
    def __init__(self, data_source: DataSource, dataset_key: str, primary_key: str, **data) -> None:
        super().__init__(data_source=data_source, dataset_key=dataset_key, primary_key=primary_key, **data)

        hash_key = (DataSource, dataset_key, self.linked_model if self.linked_model else None)
        datasets[hash_key] = self

        if self.data_source.sql_engine:
            self.sql_table = Table(self.dataset_key, MetaData(bind=self.data_source.sql_engine), autoload=True)
        
        # ensure model_key_map match both mapped_model and the corresponding table
        assert (self.linked_model and self.model_key_map) or (not self.linked_model and not self.model_key_map), 'if using linked_model and model_map_key, both are required'
        if self.linked_model and self.model_key_map:
            expected_keys = list(signature(self.linked_model).parameters)
            assert set(expected_keys) == set(self.model_key_map.keys()), 'keys of model_map_key do not match the parameters of linked_model'

            expected_values = [c.name for c in self.sql_table.c] # type: ignore

            model_key_map_values = []
            for v in self.model_key_map.values():
                if v and type(v) is str:
                    model_key_map_values.append(v)
                elif v and type(v) is dict:
                    model_key_map_values.append(next(iter(v)))

            assert all(value in expected_values for value in model_key_map_values), 'one or more values of model_map_key are not a valid column of the dataset'
    
    def get_all_rows(self) -> Optional[ResultProxy]:
        if self.data_source.sql_engine:
            results = []
            try:
                results = self.data_source.sql_engine.execute(select([self.sql_table])) # type: ignore
            except Exception as e:
                logging.warning(f'failed to get all rows for {self.dataset_key}:\n{e}')
            return results
        return None
    
    def get_row_for_primary_key(self, key: str) -> Optional[RowProxy]:
        if self.data_source.sql_engine:
            query = select([self.sql_table]).where(self.sql_table.c[self.primary_key] == key) # type: ignore
            results = self.data_source.sql_engine.execute(query).fetchone() # type: ignore
            if not results:
                logger.info(f'get_row_for_primary_key returned no results for dataset {(DataSource, self.dataset_key, self.linked_model if self.linked_model else None)} and primary_key {key}')
            return results
        return None
    
    def get_linked_model_objects(self) -> List[Any]:
        assert self.linked_model and self.model_key_map

        models: List[Any] = []
        rows = self.get_all_rows()
        if not rows:
            return models
        for row in rows:
            model = self.create_linked_model_object(row)
            if model:
                models.append(model)

        return(models)
    
    def get_linked_model_object_for_primary_key(self, key: str) -> Optional[Any]:
        assert self.linked_model and self.model_key_map
        row = self.get_row_for_primary_key(key)
        return(self.create_linked_model_object(row) if row else None)

    def create_linked_model_object(self, row: ResultProxy) -> Optional[Any]:
        flat_args = {}

        if self.model_key_map:
            for k,v in self.model_key_map.items():
                if v and type(v) is str:
                    flat_args[k] = row[v]
                elif v and type(v) is dict:
                    # assume the model_key_map contains a custom function for parsing the dataset column
                    name = list(v.keys())[0] # type: ignore
                    dataset_value = row[name]
                    flat_args[k] = v[name](dataset_value) if dataset_value else None # type: ignore
        
        args = self._hydrate_linked_model_args_by_introspection(flat_args)

        try:
            if not self.linked_model:
                return None
            instance = self.linked_model(**args)
        except Exception as e:
            logger.info(f'create_linked_model_object failed to create model {self.linked_model} with args {args}:\n{e}')
            return None
        else:
            return instance

    def _hydrate_linked_model_args_by_introspection(self, flat_args) -> Dict[str,Any]:
        existing_linked_datasets = {k[2]:v for k,v in datasets.items() if k[2]}
        args = {}

        # iterate over the parameters of the model class
        for model_param_name, model_param in signature(self.linked_model).parameters.items(): # type: ignore
            if model_param_name in flat_args.keys() and flat_args[model_param_name]:
                # there absolutely has to be a better way to determine the builtins in a class signature but I haven't found a reliable one yet. need to figure out how FastAPI does this introspection for the OpenAPI docs
                try:
                    _ = signature(model_param.annotation)
                except ValueError as err:
                    # this model parameter expects a primitive builtin type
                    if 'no signature found for builtin type' in str(err):
                        # pass corresponding value directly to the model's constructor
                        args[model_param_name] = flat_args[model_param_name]
                else:
                    # this model parameter expects a more complex type. attempt to unpack it.
                    unpacked = False
                    is_iterable = False
                    nested_model = model_param.annotation
                    while not unpacked:
                        try:
                            nested_model.__args__
                        except:
                            unpacked = True
                        else:
                            # if this isn't an Optional and it's nested, then assume it's a list
                            is_iterable = nested_model.__args__[-1] is not None
                            # assuming first arg is the one we want, is true in most cases
                            nested_model = nested_model.__args__[0]

                    if nested_model in existing_linked_datasets.keys():
                        # if a dataset linked to this model exists, assume passed value is a primary key for that model
                        dataset_for_nested_model = existing_linked_datasets[nested_model]

                        if is_iterable:
                            args[model_param_name] = [instance for key in flat_args[model_param_name] if (instance := dataset_for_nested_model.get_linked_model_object_for_primary_key(key))]
                        else:
                            args[model_param_name] = dataset_for_nested_model.get_linked_model_object_for_primary_key(flat_args[model_param_name])
                    else:
                        # if a dataset linked to this model does not exist, attempt to pass value directly to this model's constructor
                        args[model_param_name] = flat_args[model_param_name]

        return args

def generate_hf_mysql_db_address(db_ip: str, db_name: str, db_user: str, db_secret_key: str) -> str:
    secret_path = f'projects/humanity-forward/secrets/{db_secret_key}/versions/latest'
    db_pass = secret_client.access_secret_version(request={"name": secret_path}).payload.data.decode('UTF-8')
    return f'{db_user}:{db_pass}@{db_ip}/{db_name}'
