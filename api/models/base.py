<<<<<<< HEAD
from sqlalchemy.ext.declarative import declarative_base
Base = declarative_base()
=======
from sqlalchemy.ext.declarative import declarative_base # type: ignore
from sqlalchemy.dialects.postgresql import ARRAY # type: ignore

Base = declarative_base()

class CastingArray(ARRAY):
 def bind_expression(self, bindvalue):
     return cast(bindvalue, self)
>>>>>>> bf691df59a9d50ced83c5fe9b6e77a5205f5b100
