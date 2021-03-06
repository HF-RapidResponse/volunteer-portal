from fastapi import Depends, FastAPI, Form, Request, HTTPException, Header, APIRouter
from typing import List, Optional, Text, Union, Mapping, Any
from models import Account, AccountSettings
from models.notification import Notification, NotificationChannel, NotificationStatus
import notifications_manager as nm
from schemas import (AccountCreateRequestSchema, AccountResponseSchema, AccountBaseSchema,
                     AccountNewPasswordSchema, AccountSettingsSchema, AccountNotificationSchema)
from settings import Config, Session, get_db
from uuid import uuid4, UUID
from fastapi_jwt_auth import AuthJWT
from security import encrypt_password, check_encrypted_password
from datetime import datetime
import socket
import random
import decimal
from helpers import sanitize_email, row2dict
from account_api import create_access_and_refresh_tokens, delete_user
router = APIRouter()

# @router.get("/notifications/", status_code=200)
# def get_all_notifications(db: Session = Depends(get_db)):
#     return db.query(Notification).all()


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
    else:
        raise HTTPException(status_code=400,
                            detail=f"Invalid username or e-mail!")
    create_and_send_email(notification_payload, existing_acct, db)


def create_and_send_email(notification_payload: AccountNotificationSchema, existing_acct: Account, db: Session):
    email_message = None
    if existing_acct is not None:
        if notification_payload.notification_type == 'password_reset':
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

                reset_url = f'{base_url}/reset_password?hash={password_reset_hash}'
                message_body = CreateParagraph(
                    f"""We have received a request to reset your password. To reset your password,
                        please click the following""")
                message_body += CreateButton("Reset Password", reset_url)
                message_body += CreateParagraph("This link will expire in 15 minutes")
            else:
                oauth_type = existing_acct.oauth.capitalize()
                message_body = CreateParagraph(
                    f"""We have received a request to reset your password.
                    Your account was created with {oauth_type} OAuth; therefore,
                    you cannot set or reset a password.
                    Please try signing in with {oauth_type}.""")
            message_body += CreateParagraph(
                '<b>If this action was not performed by you, please ignore this message.</b>')

            email_message = BASE_EMAIL_TEMPLATE.format(body_text=message_body)
            nm.send_notification(recipient=existing_acct.email, message=email_message,
                                 channel=NotificationChannel.EMAIL, scheduled_send_date=datetime.now(), subject='HF Volunteer Portal Password Reset')
        elif notification_payload.notification_type == 'verify_registration':
            base_url = Config['routes']['client']
            acct_settings = db.query(AccountSettings).filter_by(
                uuid=existing_acct.uuid).first()
            curr_time = datetime.now()
            verify_account_hash = generate_str_for_hash(
                existing_acct.username, curr_time)
            acct_settings.verify_account_hash = verify_account_hash
            cancel_registration_hash = generate_str_for_hash(
                existing_acct.username, curr_time)
            acct_settings.cancel_registration_hash = cancel_registration_hash
            db.merge(acct_settings)
            db.commit()

            verify_url = f'{base_url}/verify_account?hash={verify_account_hash}'
            cancel_url = f'{base_url}/cancel_registration?hash={cancel_registration_hash}'

            message_body = CreateParagraph(f'Hi {existing_acct.first_name},')
            message_body += CreateParagraph(
                f"""We have received a request to create an account associated with this email.
                Please click below to verify your account""")
            message_body += CreateButton("Verify My Account", verify_url)

            message_body += CreateParagraph(
                f"""If this action was not performed by you or performed by accident,
                you may click the following to undo account creation""")
            message_body += CreateButton("Undo Account Registration", cancel_url)

            email_message = BASE_EMAIL_TEMPLATE.format(body_text=message_body)

            nm.send_notification(recipient=existing_acct.email, message=email_message,
                                 channel=NotificationChannel.EMAIL, scheduled_send_date=datetime.now(), subject='HF Volunteer Portal Account Registration')


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


@router.get("/verify_account_from_hash", status_code=200)
def complete_account_registration(verify_hash: str, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    settings = db.query(AccountSettings).filter_by(
        verify_account_hash=verify_hash).first()
    if settings is not None:
        acct_uuid = settings.uuid
        settings.verify_account_hash = None
        settings.cancel_registration_hash = None
        db.merge(settings)
        db.commit()
        account = db.query(Account).filter_by(
            uuid=acct_uuid).first()
        if account is not None:
            account.is_verified = True
            db.merge(account)
            db.commit()
            create_access_and_refresh_tokens(
                str(acct_uuid), Authorize)
            user = row2dict(account)
            user.update(row2dict(settings))
            return user
    else:
        raise HTTPException(status_code=400,
                            detail=f"invalid hash or account does not exist")


@router.delete("/cancel_registration_from_hash", status_code=204)
def cancel_account_registration(cancel_hash: str, db: Session = Depends(get_db)):
    settings_to_delete = db.query(AccountSettings).filter_by(
        cancel_registration_hash=cancel_hash).first()
    if settings_to_delete is None:
        raise HTTPException(status_code=400,
                            detail=f"Account settings with hash {cancel_hash} not found")
    acct_uuid = settings_to_delete.uuid
    delete_user(acct_uuid, db)


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

background_color = "#f3f2ef"
card_background_color = "#ffffff"
button_color = "#399DAC"
# For email header image
base_url = Config['routes']['client']
if 'localhost' in base_url:
    # use publicly available image when testing on dev
    base_url = 'https://staging-volunteer-portal-dv734ug3ua-uc.a.run.app'

#This template contains a card  with the HF rapid response volunteer program logo.
# paragraphs and buttons should be added as <tr><td> elements. Use the CreateParagraph helper method
# and concatenate the paragraph strings and insert into the template using the body_text template variable.
# Try to keep this in sync with the style from the CSS element .shadow-card in the client
BASE_EMAIL_TEMPLATE = f"""
<body style="margin: 0; padding: 0; background-color: {background_color}; font-family: Verdana, Geneva, sans-serif;">
    <table border="0" cellpadding="0" cellspacing="0" width="100%" style="padding:40px 0 0 0;">
        <tr>
            <td>
                <table align="center" border="0" cellpadding="0" cellspacing="0" width="600" bgcolor="#ffffff" style="margin: 2rem auto; padding: 2rem; background: {card_background_color}; box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px; border-radius: 4px;">
                    <tr>
                        <td align="center" style="padding: 20px 20px 20px 20px;"> <a href="{base_url}"><img src="{base_url}/static/media/HF-RR-long-logo.8e1b9513.png" alt="Volunteer Portal Logo" title="Volunteer Portal Logo" style="display: block; width:80%; height:auto;" /></a>

                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 30px 20px 30px 20px;">
                            <table border="0" cellpadding="0" cellspacing="0" width="100%" style="font-size:16px;">
                            {{body_text}}
                             <tr><td style="padding: 20px 0 20px 0;">Regards, <br/>HF Volunteer Portal Team</tr></td>'
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
"""

# Try to keep this in sync with the style from the CSS element .btn and .btn-info in the client
BUTTON_TEMPLATE = f"""<tr><td align="center">
<a href="{{link}}" style="display: inline-block; font-weight: 400; color: #212529;
text-align: center; vertical-align: middle; -webkit-user-select: none; user-select: none; border:
1px solid transparent; padding: .375rem .75rem; font-size: 1rem; line-height: 1.5;
border-radius: .25rem; color: #fff; background-color: {button_color}; border-color: {button_color};
text-decoration: none; margin: 1rem auto;">
{{button_text}}
</a></td></tr>"""

def CreateButton(button_text, link):
    return BUTTON_TEMPLATE.format(link=link, button_text=button_text)

def CreateParagraph(text):
    return f'<tr><td style="padding: 20px 0 20px 0;">{text}</td></tr>'
