from sqlalchemy.ext.declarative import declarative_base # type: ignore
from sqlalchemy.dialects.postgresql import ARRAY # type: ignore

Base = declarative_base()

class CastingArray(ARRAY):
 def bind_expression(self, bindvalue):
     return cast(bindvalue, self)
