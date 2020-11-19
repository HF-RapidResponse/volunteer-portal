from typing import Dict, Type, Optional
from inspect import signature

from pydantic import BaseModel, validator, root_validator
from pydantic.validators import dict_validator

from data_sources import get_dataset_for_model

class SelfHydratingModel(BaseModel):
    fields_to_self_hydrate: Optional[Dict[str,Type]] = None

    @validator('*', pre=True, allow_reuse=True)
    def hydrate_fields(cls, v, values, field):
        if 'fields_to_self_hydrate' in values and values['fields_to_self_hydrate'] and field.name in values['fields_to_self_hydrate']:
            model = values['fields_to_self_hydrate'][field.name]
            return cls.fetch_model_for_field(v, model)
        else:
            return v

    @classmethod
    def fetch_model_for_field(cls: Type, v, field_model: Type):
        def get_model_for_primary_key(v, field_model: Type):
            dataset = get_dataset_for_model(field_model)
            if dataset:
                return dataset.get_linked_model_object_for_primary_key(v)
            else:
                return v
        
        if type(v) is str:
            # v is a primitive string, attempt to fetch pydantic object by ID
            return get_model_for_primary_key(v, field_model)
        elif type(v) is list:
            if v and type(v[-1]) is str:
                # v is a list of primitive strings, attempt to fetch list of pydantic objects
                # this filters out nested objects that fail validation
                return [instance for key in v if (instance := get_model_for_primary_key(key, field_model))]
            else:
                return v
        else:
            # v is either a pydantic object, a valid dict of keys for that model, or an invalid input
            # Let pydantic field validation handle organically
            return v

class SelfHydratingModelMock(SelfHydratingModel):
    @classmethod
    def fetch_model_for_field(cls: Type, v, field_model: Type):
        print(f'hydrating value {v} as model {field_model}')
        return v

class TestGrandchildClass(SelfHydratingModelMock):
    name: str

class TestChildClassOne(SelfHydratingModelMock):
    name: str
    grandchild: TestGrandchildClass

    def __init__(self, **kwargs):
        fields_to_self_hydrate = {
            'grandchild': TestGrandchildClass
        }

        super().__init__(fields_to_self_hydrate=fields_to_self_hydrate, **kwargs)

class TestChildClassTwo(SelfHydratingModelMock):
    name: str

class TestParentClass(SelfHydratingModelMock):
    name: str
    child_one: TestChildClassOne
    child_two: TestChildClassTwo

    def __init__(self, **kwargs):
        fields_to_self_hydrate = {
            'child_one': TestChildClassOne,
            'child_two': TestChildClassTwo
        }

        super().__init__(fields_to_self_hydrate=fields_to_self_hydrate, **kwargs)

grandchild = TestGrandchildClass(name='grandchild from keys')

child_one_from_keys = TestChildClassOne(name='child one from keys', grandchild={'name': 'grandchild from keys'})

child_one_from_models = TestChildClassOne(name='child one from models', grandchild=grandchild)

child_two = TestGrandchildClass(name='child two')

parent_from_keys = TestParentClass(
    name='parent from keys',
    child_one={'name':'another child one from keys', 'grandchild':{'name':'another grandchild from keys'}},
    child_two={'name':'another child two'}
)

parent_from_models = TestParentClass(name='parent from keys', child_one=child_one_from_models, child_two=child_two)

print(parent_from_keys)