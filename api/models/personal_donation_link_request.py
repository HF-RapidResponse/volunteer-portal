from pydantic import BaseModel, EmailStr
from datetime import datetime, timezone
NowUtc = lambda: datetime.now(tz=timezone.utc)
from data_sources import DataSink
from settings import connections, donations

import logging
logging.basicConfig(level=logging.INFO)

class PersonalDonationLinkRequest(BaseModel):
    email: EmailStr
    request_sent: datetime = NowUtc()

    # def insert(link_request):
        # if db().insert(link_request)
        #     logging.debug(f'Inserting {link_request} to db')
        # else
        #     logging.error('Cannot insert to donation link DB, connecting failed.')
        #
        # return link_request

def db():
    d = DataSink(data_base_type=donations['engine'], address=connections['donations'], table='link_requests')
    d: Optional[DataSink] = None
    return d
