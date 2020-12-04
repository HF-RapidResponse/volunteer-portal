from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.dialects.postgresql import ARRAY

Base = declarative_base()

class CastingArray(ARRAY):
 def bind_expression(self, bindvalue):
     return cast(bindvalue, self)
