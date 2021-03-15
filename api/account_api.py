from fastapi import Depends, FastAPI, Form, Request, HTTPException, Header, APIRouter
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional, Text, Union, Mapping, Any
from models import Account, AccountSettings
from schemas import (AccountRequestSchema, AccountResponseSchema,
                     PartialAccountSchema, AccountSettingsSchema)
from sqlalchemy.orm import lazyload
from starlette.middleware.sessions import SessionMiddleware
from fastapi.responses import JSONResponse
from fastapi_jwt_auth.exceptions import AuthJWTException
from fastapi.encoders import jsonable_encoder
import auth
from settings import Config, Session, get_db
import logging
from uuid import uuid4, UUID
from fastapi_jwt_auth import AuthJWT
import external_data_sync
from security import encrypt_password, check_encrypted_password
import re

router = APIRouter()

# Note: I am leaving this route commented out as it should not be available publicly.
# However, it is useful to have when running locally for debugging purposes
# @router.get("/accounts/", response_model=List[AccountResponseSchema])
# def get_all_accounts(db: Session = Depends(get_db)):
#     return db.query(Account).all()


@router.get("/accounts/{uuid}", response_model=AccountResponseSchema)
def get_account_by_uuid(uuid, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    return db.query(Account).filter_by(uuid=uuid).first()


@router.post("/accounts/", response_model=AccountResponseSchema, status_code=201)
def create_account(account: AccountRequestSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    check_for_existing_username_or_email(account, db)
    if account.password is not None:
        check_valid_password(account.password)
        account.password = encrypt_password(account.password)
    account = Account(**account.dict())
    db.add(account)
    db.commit()
    create_access_and_refresh_tokens(str(account.uuid), Authorize)
    return account


def check_valid_password(password: str):
    match = re.search(
        "^.*(?=.*\d)(?=.*[a-zA-Z])(?=.*\d)(?=.*[`!@#$%^&*()_+\-=[\]{};':\"\\|,.<>/?~]).{6,20}$", password)
    if match is None:
        raise HTTPException(status_code=400,
                            detail=f"Please enter a password between 6 and 20 characters long with at least 1 letter, 1 number, and 1 special character.")


def check_for_existing_username_or_email(account: AccountRequestSchema, db: Session):
    existing_acct = db.query(Account).filter_by(email=account.email).first()
    errors = {}
    if existing_acct is not None:
        errors['email'] = f"An account with the email address {account.email} already exists"
    existing_acct = db.query(Account).filter_by(
        username=account.username).first()
    if existing_acct is not None:
        errors['username'] = f"An account with the username {account.username} already exists"
    print('Are we here?', errors)
    if len(errors) > 0:
        raise HTTPException(
            status_code=400, detail=errors)


def create_access_and_refresh_tokens(user_id: str, Authorize: AuthJWT):
    try:
        access_token = Authorize.create_access_token(subject=user_id)
        Authorize.set_access_cookies(access_token)
        refresh_token = Authorize.create_refresh_token(subject=user_id)
        Authorize.set_refresh_cookies(refresh_token)
    except:
        raise HTTPException(
            status_code=500, detail=f"Error while trying to create and refresh tokens")


@router.put("/accounts/{uuid}", response_model=AccountResponseSchema)
def update_account(uuid, account: AccountRequestSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_for_diff_user_with_same_username(uuid, account, db)
    updated_acct = Account(uuid=uuid, **account.dict())
    db.merge(updated_acct)
    db.commit()
    return updated_acct


def check_for_diff_user_with_same_username(uuid, account: AccountRequestSchema, db: Session):
    existing_acct = db.query(Account).filter_by(
        username=account.username).first()
    if existing_acct is not None and str(uuid) != str(existing_acct.uuid):
        raise HTTPException(status_code=400,
                            detail=f"Account with username {existing_acct.username} already exists!")


@router.patch("/accounts/{uuid}", response_model=AccountResponseSchema)
def update_password(uuid, partial_account: PartialAccountSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    account = db.query(Account).filter_by(uuid=uuid).first()
    if partial_account.password is None:
        raise HTTPException(
            status_code=400, detail=f"Password is missing")
    else:
        check_valid_password(partial_account.password)
        account.password = encrypt_password(partial_account.password)
    db.merge(account)
    db.commit()
    db.refresh(account)
    return account


@router.delete("/accounts/{uuid}", status_code=204)
def delete_account(uuid, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    acct_to_delete = db.query(Account).filter_by(uuid=uuid).first()
    if acct_to_delete is None:
        raise HTTPException(status_code=400,
                            detail=f"Account with UUID {uuid} not found")
    db.delete(acct_to_delete)
    db.commit()


@router.post("/account_settings/", response_model=AccountSettingsSchema, status_code=201)
def create_settings(settings: AccountSettingsSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    existing_settings = db.query(AccountSettings).filter_by(
        uuid=settings.uuid).first()
    if existing_settings is not None:
        raise HTTPException(
            status_code=400, detail=f"Settings already exist for that account")

    new_settings = AccountSettings(**settings.dict())
    db.add(new_settings)
    db.commit()
    create_access_and_refresh_tokens(str(settings.uuid), Authorize)
    return new_settings


@router.get("/account_settings/", response_model=List[AccountSettingsSchema])
def get_all_settings(db: Session = Depends(get_db)):
    return db.query(AccountSettings).all()


@router.get("/account_settings/{uuid}", response_model=AccountSettingsSchema)
def get_settings_by_uuid(uuid, db: Session = Depends(get_db)):
    return db.query(AccountSettings).filter_by(uuid=uuid).first()


@router.put("/account_settings/{uuid}", response_model=AccountSettingsSchema)
def update_settings(uuid, settings: AccountSettingsSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    updated_settings = AccountSettings(**settings.dict())
    db.merge(updated_settings)
    db.commit()
    return updated_settings


@router.delete("/account_settings/{uuid}", status_code=204)
def delete_settings(uuid, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    settings_to_delete = db.query(AccountSettings).filter_by(uuid=uuid).first()
    if settings_to_delete is None:
        raise HTTPException(status_code=400,
                            detail=f"Settings with UUID {uuid} not found")
    db.delete(settings_to_delete)
    db.commit()
