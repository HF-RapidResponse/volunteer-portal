import logging
from uuid import UUID
import re
from fastapi import Depends, HTTPException, APIRouter
from fastapi_jwt_auth import AuthJWT
from typing import List
from models import Account, AccountSettings, EmailIdentifier
from schemas import (AccountCreateRequestSchema, AccountResponseSchema, AccountBaseSchema,
                     AccountNewPasswordSchema, AccountSettingsSchema)
from initiatives_api import GetAllInitiativeNames
from settings import Session, get_db
from identifiers_helper import IdentifierState, get_or_create_identifier

from security import encrypt_password

router = APIRouter()

# Note: I am leaving these get all routes commented out as they should not be available publicly.
# However, they're useful to have when running locally for debugging purposes


# @router.get("/accounts/", response_model=List[AccountResponseSchema])
# def get_all_accounts(db: Session = Depends(get_db)):
#     return db.query(Account).all()


# @router.get("/account_settings/", status_code=200)
# def get_all_account_settings(db: Session = Depends(get_db)):
#     return db.query(AccountSettings).all()


def create_access_and_refresh_tokens(user_id: str, Authorize: AuthJWT):
    try:
        access_token = Authorize.create_access_token(subject=user_id)
        Authorize.set_access_cookies(access_token)
        refresh_token = Authorize.create_refresh_token(subject=user_id)
        Authorize.set_refresh_cookies(refresh_token)
    except:
        raise HTTPException(
            status_code=500, detail="Error while trying to create and refresh tokens")


def check_valid_password(password: str):
    match = re.search(
        r"^.*(?=.*\d)(?=.*[a-zA-Z])(?=.*\d)(?=.*[`!@#$%^&*()_+\-=[\]{};':\"\\|,.<>/?~]).{6,20}$",
        password)
    if match is None:
        raise HTTPException(
            status_code=400,
            detail="Please enter a password between 6 and 20 characters long with at least "
            "1 letter, 1 number, and 1 special character.")


def check_matching_user(uuid, Authorize: AuthJWT):
    current_uuid = Authorize.get_jwt_subject()
    if current_uuid != uuid:
        raise HTTPException(status_code=403, detail="unauthorized")


@router.get("/accounts/{uuid}", response_model=AccountResponseSchema)
def get_account_by_uuid(uuid, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)
    return db.query(Account).filter_by(uuid=uuid).first()


@router.post("/accounts/", response_model=AccountResponseSchema, status_code=201)
def create_account(request: AccountCreateRequestSchema,
                   Authorize: AuthJWT = Depends(),
                   db: Session = Depends(get_db)):
    account = request.account
    identifier = request.identifier
    password = request.password

    id_state, identifier = get_or_create_identifier(identifier.type,
                                                    identifier.identifier,
                                                    db,
                                                    EmailIdentifier)
    check_identifier_on_create(id_state, identifier)
    check_for_existing_username(account.username, db)
    new_account = Account(**account.dict())
    if password is not None:
        check_valid_password(password)
        new_account.password = encrypt_password(password)

    db.add(new_account)
    db.commit()

    new_account.primary_email_identifier = identifier

    create_account_settings(new_account.uuid, db)
    create_access_and_refresh_tokens(str(new_account.uuid), Authorize)
    db.commit()
    db.flush()
    db.refresh(new_account)

    return new_account


def create_account_settings(uuid, db):
    existing_settings = db.query(AccountSettings).filter_by(
        uuid=uuid).first()
    if existing_settings is not None:
        raise HTTPException(
            status_code=400, detail="Settings already exist for that account")
    matching_acct = db.query(Account).filter_by(uuid=uuid).first()
    if matching_acct is None:
        raise HTTPException(
            status_code=400, detail=f"Account with UUID {uuid} does not exist. Cannot create settings")
    initiative_map = {i[0]: False for i in GetAllInitiativeNames(db)}
    new_settings = AccountSettings(
        **{"uuid": uuid, 'account_uuid': uuid, 'initiative_map': initiative_map})
    db.add(new_settings)
    db.commit()
    return new_settings


def check_identifier_on_create(id_state, identifier):
    if id_state is IdentifierState.HAS_ACCOUNT_NOT_VERIFIED or \
       id_state is IdentifierState.HAS_ACCOUNT_IS_VERIFIED:
        message = f"An account with the {identifier.type.value} {identifier.value} already exists"
        raise HTTPException(
            status_code=400, detail={identifier.type.value: message})

def check_for_existing_username(username: str, db: Session):

    existing_acct = db.query(Account).filter_by(
        username=username).first()
    if existing_acct is not None:
        message = f"An account with the username {username} already exists"
        raise HTTPException(
            status_code=400, detail={'username': message})


@router.put("/accounts/{uuid}", response_model=AccountResponseSchema)
def update_account(uuid, account: AccountBaseSchema, Authorize: AuthJWT = Depends(),
                   db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)
    check_for_diff_user_with_same_username(uuid, account, db)
    updated_acct = Account(uuid=uuid, **account.dict())
    account = db.merge(updated_acct)
    db.commit()
    return account


def check_for_diff_user_with_same_username(uuid, account: AccountCreateRequestSchema, db: Session):
    existing_acct = db.query(Account).filter_by(
        username=account.username).first()
    if existing_acct is not None and str(uuid) != str(existing_acct.uuid):
        raise HTTPException(status_code=400,
                            detail=f"Account with username {existing_acct.username} already exists!")


@router.patch("/accounts/{uuid}", response_model=AccountResponseSchema)
def update_password(uuid, partial_account: AccountNewPasswordSchema, Authorize: AuthJWT = Depends(),
                    db: Session = Depends(get_db)):
    try:
        Authorize.jwt_required()
        check_matching_user(uuid, Authorize)
        account = db.query(Account).filter_by(uuid=uuid).first()
        if partial_account.password is None:
            raise HTTPException(
                status_code=400, detail="Password is missing")
        check_valid_password(partial_account.password)
        account.password = encrypt_password(partial_account.password)
        db.merge(account)
        db.commit()
        db.refresh(account)
    except Exception as e:
        logging.warning(e)
        raise e
    return account


@router.delete("/accounts/{uuid}", status_code=204)
def remove_user(uuid, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)
    delete_user(uuid, db)


def delete_user(uuid: UUID, db: Session):
    # deleting the account cascades to delete account settings, identifiers, and verification tokens
    delete_account(uuid, db)


def delete_account(uuid: UUID, db: Session):
    acct_to_delete = db.query(Account).filter_by(uuid=uuid).first()
    if acct_to_delete is None:
        raise HTTPException(status_code=400,
                            detail=f"Account with UUID {uuid} not found")
    db.delete(acct_to_delete)
    db.commit()


@router.get("/account_settings/{uuid}", response_model=AccountSettingsSchema)
def get_settings_by_uuid(uuid, db: Session = Depends(get_db), Authorize: AuthJWT = Depends()):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)
    return db.query(AccountSettings).filter_by(uuid=uuid).first()


@router.put("/account_settings/{uuid}", response_model=AccountSettingsSchema)
def update_settings(uuid, settings: AccountSettingsSchema, Authorize: AuthJWT = Depends(),
                    db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)
    updated_settings = AccountSettings(**settings.dict())
    db.merge(updated_settings)
    db.commit()
    return updated_settings
