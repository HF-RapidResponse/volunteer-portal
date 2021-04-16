from fastapi import Depends, FastAPI, Form, Request, HTTPException, Header, APIRouter
from fastapi.middleware.cors import CORSMiddleware
from typing import List, Optional, Text, Union, Mapping, Any
from models import Account, AccountSettings
from schemas import (AccountCreateRequestSchema, AccountResponseSchema,
                     AccountNewPasswordSchema, AccountSettingsSchema, AccountBaseSchema)
from models.notification import Notification, NotificationChannel, NotificationStatus
import notifications_manager as nm
from schemas import (AccountCreateRequestSchema, AccountResponseSchema, AccountBaseSchema,
                     AccountNewPasswordSchema, AccountSettingsSchema, AccountNotificationSchema)
from sqlalchemy import or_
from sqlalchemy.orm import lazyload
from starlette.middleware.sessions import SessionMiddleware
from fastapi.responses import JSONResponse
from fastapi_jwt_auth.exceptions import AuthJWTException
from fastapi.encoders import jsonable_encoder
from initiatives_api import GetAllInitiativeNames
from settings import Config, Session, get_db
from security import encrypt_password
import logging
from uuid import uuid4, UUID
from fastapi_jwt_auth import AuthJWT
import external_data_sync
from security import encrypt_password, check_encrypted_password
import re
from datetime import datetime
import socket
import random
import decimal
from helpers import sanitize_email
router = APIRouter()

# Note: I am leaving these get all routes commented out as they should not be available publicly.
# However, they're useful to have when running locally for debugging purposes


# @router.get("/accounts/", response_model=List[AccountResponseSchema])
# def get_all_accounts(db: Session = Depends(get_db)):
#     return db.query(Account).all()


# @router.get("/account_settings/", status_code=200)
# def get_all_account_settings(db: Session = Depends(get_db)):
#     return db.query(AccountSettings).all()


# @router.get("/notifications/", status_code=200)
# def get_all_notifications(db: Session = Depends(get_db)):
#     return db.query(Notification).all()


def create_access_and_refresh_tokens(user_id: str, Authorize: AuthJWT):
    try:
        access_token = Authorize.create_access_token(subject=user_id)
        Authorize.set_access_cookies(access_token)
        refresh_token = Authorize.create_refresh_token(subject=user_id)
        Authorize.set_refresh_cookies(refresh_token)
    except:
        raise HTTPException(
            status_code=500, detail=f"Error while trying to create and refresh tokens")


def check_valid_password(password: str):
    match = re.search(
        "^.*(?=.*\d)(?=.*[a-zA-Z])(?=.*\d)(?=.*[`!@#$%^&*()_+\-=[\]{};':\"\\|,.<>/?~]).{6,20}$", password)
    if match is None:
        raise HTTPException(status_code=400,
                            detail=f"Please enter a password between 6 and 20 characters long with at least 1 letter, 1 number, and 1 special character.")


def check_matching_user(uuid, Authorize: AuthJWT):
    current_uuid = Authorize.get_jwt_subject()
    if current_uuid != uuid:
        raise HTTPException(status_code=403, detail=f"unauthorized")


@router.get("/accounts/{uuid}", response_model=AccountResponseSchema)
def get_account_by_uuid(uuid, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)
    return db.query(Account).filter_by(uuid=uuid).first()


@router.post("/accounts/", response_model=AccountResponseSchema, status_code=201)
def create_account(account: AccountCreateRequestSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    check_for_existing_username_or_email(account, db)
    if account.password is not None:
        check_valid_password(account.password)
        account.password = encrypt_password(account.password)
    account = Account(**account.dict())
    db.add(account)
    db.commit()
    create_account_settings(account.uuid, db)
    create_access_and_refresh_tokens(str(account.uuid), Authorize)
    return account


def create_account_settings(uuid, db):
    existing_settings = db.query(AccountSettings).filter_by(
        uuid=uuid).first()
    if existing_settings is not None:
        raise HTTPException(
            status_code=400, detail=f"Settings already exist for that account")
    matching_acct = db.query(Account).filter_by(uuid=uuid).first()
    if matching_acct is None:
        raise HTTPException(
            status_code=400, detail=f"Account with UUID {uuid} does not exist. Cannot create settings")
    initiative_map = {i[0]: False for i in GetAllInitiativeNames(db)}
    new_settings = AccountSettings(
        **{"uuid": uuid, 'initiative_map': initiative_map})
    db.add(new_settings)
    db.commit()
    return new_settings


def check_for_existing_username_or_email(account: AccountBaseSchema, db: Session):
    existing_acct = db.query(Account).filter_by(email=account.email).first()
    errors = {}
    if existing_acct is not None:
        errors['email'] = f"An account with the email address {account.email} already exists"
    existing_acct = db.query(Account).filter_by(
        username=account.username).first()
    if existing_acct is not None:
        errors['username'] = f"An account with the username {account.username} already exists"
    if len(errors) > 0:
        raise HTTPException(
            status_code=400, detail=errors)


@router.put("/accounts/{uuid}", response_model=AccountResponseSchema)
def update_account(uuid, account: AccountBaseSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)
    check_for_diff_user_with_same_username(uuid, account, db)
    updated_acct = Account(uuid=uuid, **account.dict())
    db.merge(updated_acct)
    db.commit()
    return updated_acct


def check_for_diff_user_with_same_username(uuid, account: AccountCreateRequestSchema, db: Session):
    existing_acct = db.query(Account).filter_by(
        username=account.username).first()
    if existing_acct is not None and str(uuid) != str(existing_acct.uuid):
        raise HTTPException(status_code=400,
                            detail=f"Account with username {existing_acct.username} already exists!")


@router.patch("/accounts/{uuid}", response_model=AccountResponseSchema)
def update_password(uuid, partial_account: AccountNewPasswordSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    try:
        Authorize.jwt_required()
        check_matching_user(uuid, Authorize)
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
    except Exception as e:
        logging.warning(e)
        raise e
    return account


@router.delete("/accounts/{uuid}", status_code=204)
def delete_account(uuid, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)
    acct_to_delete = db.query(Account).filter_by(uuid=uuid).first()
    if acct_to_delete is None:
        raise HTTPException(status_code=400,
                            detail=f"Account with UUID {uuid} not found")
    db.delete(acct_to_delete)
    db.commit()
    delete_settings(uuid, db)


def delete_settings(uuid, db):
    settings_to_delete = db.query(AccountSettings).filter_by(uuid=uuid).first()
    if settings_to_delete is None:
        raise HTTPException(status_code=400,
                            detail=f"Settings with UUID {uuid} not found")
    db.delete(settings_to_delete)
    db.commit()


@router.get("/account_settings/{uuid}", response_model=AccountSettingsSchema)
def get_settings_by_uuid(uuid, db: Session = Depends(get_db), Authorize: AuthJWT = Depends()):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)
    return db.query(AccountSettings).filter_by(uuid=uuid).first()


@router.put("/account_settings/{uuid}", response_model=AccountSettingsSchema)
def update_settings(uuid, settings: AccountSettingsSchema, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)
    updated_settings = AccountSettings(**settings.dict())
    db.merge(updated_settings)
    db.commit()
    return updated_settings


@router.post("/notifications/", status_code=204)
def create_notification(notification_payload: AccountNotificationSchema, db: Session = Depends(get_db)):
    existing_acct = None
    if notification_payload.email is not None:
        existing_acct = db.query(Account).filter_by(
            email=notification_payload.email).first() or db.query(Account).filter_by(
                email=sanitize_email(notification_payload.email)).first()
    elif notification_payload.username is not None:
        existing_acct = db.query(Account).filter_by(
            username=notification_payload.username.strip()).first()

    email_message = None
    if existing_acct is not None:
        email_message = f'<p>Dear {existing_acct.first_name},</p>'
        if existing_acct.oauth is None:
            base_url = Config['routes']['client']
            acct_settings = db.query(AccountSettings).filter_by(
                uuid=existing_acct.uuid).first()
            curr_time = datetime.now()
            password_reset_hash = generate_str_for_hash(
                existing_acct.username, curr_time)
            acct_settings.password_reset_hash = password_reset_hash
            acct_settings.password_reset_time = curr_time
            db.merge(acct_settings)
            db.commit()

            url_to_click = f'{base_url}/reset_password?hash={password_reset_hash}'
            email_message += f'<p>We have received a request to reset your password. To reset your password, \
                please click the following link: <a href="{url_to_click}">change my password</a></p> \
                <p>This link will expire in 15 minutes.</p>'
        else:
            oauth_type = existing_acct.oauth.capitalize()
            email_message += f'<p>We have received a request to reset your password. \
                Your account was created with {oauth_type} OAuth; therefore, \
                you cannot set or reset a password. \
                Please try signing in with {oauth_type}.</p>'
        email_message += '<b> If this action was not performed by you, \
                someone may be targeting your account. You may want to consider changing your e-mail password. </b>\
                <p>Regards, <br/>HF Volunteer Portal Team </p>'
        nm.send_notification(recipient=existing_acct.email, message=email_message,
                             channel=NotificationChannel.EMAIL, scheduled_send_date=datetime.now(), subject='HF Volunteer Portal Password Reset')


@router.get("/settings_from_hash", status_code=200)
def get_settings_from_hash(pw_reset_hash: str, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    existing_settings = db.query(AccountSettings).filter_by(
        password_reset_hash=pw_reset_hash).first()
    if existing_settings is not None:
        time_diff = minutes_difference(existing_settings.password_reset_time)
        if time_diff >= 15:
            existing_settings.password_reset_hash = None
            existing_settings.password_reset_time = None
            db.merge(existing_settings)
            db.commit()
            raise HTTPException(status_code=400,
                                detail=f"Invalid or expired password reset URL!")
        else:
            create_access_and_refresh_tokens(
                str(existing_settings.uuid), Authorize)
            return existing_settings
    else:
        raise HTTPException(status_code=400,
                            detail=f"Invalid or expired password reset URL!")


def generate_str_for_hash(username: str, curr_time: datetime):
    one_rand_num = random.uniform(1, 101)
    password_reset_hash = encrypt_password(
        username +
        str(curr_time) + str(random.uniform(1, one_rand_num)
                             + random.uniform(1, one_rand_num) + random.uniform(1, one_rand_num)))
    return password_reset_hash


def minutes_difference(reset_req_time: datetime):
    curr_time = datetime.now()
    seconds_diff = abs((curr_time - reset_req_time).seconds)
    minutes_diff = seconds_diff/60
    return minutes_diff
