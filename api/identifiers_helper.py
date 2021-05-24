from enum import Enum
from sqlalchemy import and_

from models import PersonalIdentifier

class IdentifierState(Enum):
    NO_ACCOUNT_NOT_VERIFIED = 1
    NO_ACCOUNT_IS_VERIFIED = 2
    HAS_ACCOUNT_NOT_VERIFIED = 3
    HAS_ACCOUNT_IS_VERIFIED = 4
    NONE_MATCHING = 5

def get_identifier(id_type, value, db, id_class=PersonalIdentifier):
    existing_identifier = db.query(id_class).filter(
        and_(id_class.type == id_type,
             id_class.value == value)).first()

    if not existing_identifier:
        return IdentifierState.NONE_MATCHING, None
    if not existing_identifier.account:
        if not existing_identifier.verified:
            return IdentifierState.NO_ACCOUNT_NOT_VERIFIED, existing_identifier
        return IdentifierState.NO_ACCOUNT_IS_VERIFIED, existing_identifier

    else:
        if not existing_identifier.verified:
            return IdentifierState.HAS_ACCOUNT_NOT_VERIFIED, existing_identifier
        return IdentifierState.HAS_ACCOUNT_IS_VERIFIED, existing_identifier

def get_or_create_identifier(id_type, value, db, id_class=PersonalIdentifier):
    state, identifier = get_identifier(id_type, value, db)
    print("Bbbbbbbbb", value)
    if state == IdentifierState.NONE_MATCHING:
        print("ccccccccccccccccc", value)
        new_identifier = id_class(type=id_type, value=value)
        print("NEW ID", new_identifier)
        db.add(new_identifier)
        identifier = new_identifier
        db.commit()
    return state, identifier
