# A base class for converting nested json responses to flat sqlAlchemy objects

class ApiResponseConverter(object):
  """This base class expects field_map and sql_model objects to be set in a subclass.

     A valid field_map is a dictionary where the keys are the destination column name
     and the values are "." separated paths to the source field. See the example below
     Any field not present in the json response will result in a None value. Use a custom transform
     if an exception should be thrown for a missing field.

     custom transforms can be applied to each column by specificying a dictionary where the keys
     are the column names and the value is a function object which accepts a single argument,
     the value from the json response, and returns the transformed value. See Below.

     additional_fields may be added to each object by specifying a dictionary in which the keys
     are the column name and the value is an arg-less function object which returns the additional
     field value.

         json response:
         {
           "data": {
             "age": 10,
             "eye-color": "brown"
           },
           "response_sent": "10:23:33-07"
         }

         field_map = {"person_age": "data.age", "received": "request_sent"}
         custom_transforms = {"received": ParseTimestamp}

    The above data and specification could be used for a sqlAlchemy model with 2 columns, "age" and
    "received" with types int and datetime (assuming that is what ParseTimestamp returns).

    The sqlAlchemy model may have more fields, but they will always be null in this example.
"""

  custom_transforms = {}
  additional_fields = {}

  def __init__(self):
    assert hasattr(self, "field_map"), "field_map not defined in subclass"
    assert hasattr(self, "sql_model"), "sql alchemy model type not set"

  def UnpackRecordFromJson(self, response):
    rec = {}
    for k, v in list(self.field_map.items()):
      val = self.GetField(v, response)
      if k in self.custom_transforms:
        val = self.custom_transforms[k](val)
      rec[k] = val
    for k, fn in self.additional_fields.items():
      rec[k] = fn()
    return rec

  def GetField(self, field_name, record):
    field_name = field_name.split('.')
    for f in field_name:
      if not record:
        break
      record = record.get(f, None)
    return record

  def Convert(self, row):
    assert type(row) == dict, "Converter expects a single row as a dictionary"
    flat_fields = self.UnpackRecordFromJson(row)
    return self.sql_model(**flat_fields)

  def GetDBModel(self):
    return self.sql_model
