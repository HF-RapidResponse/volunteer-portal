import logging

from fastapi import Depends, HTTPException, APIRouter
from schemas import SubscribeRequest, UnsubscribeRequest
from models import Initiative, Subscription
from settings import Session, get_db, Config
from auth import get_logged_in_user
from identifiers_helper import get_or_create_identifier, IdentifierState, get_identifier
from models import Subscription, SubscriptionEntity, VerificationToken, NotificationChannel
from auth import get_verification_url_for_token
from notifications_api import create_subscription_verification_email
from account_api import check_matching_user
from initiatives_api import GetAllInitiatives

from fastapi_jwt_auth import AuthJWT
import notifications_manager
router = APIRouter()

# map the entity type to a DB orm object and function for extracting values needed
# for the notification
entity_type_map = {'initiative': (Initiative, lambda x: {'name': x.initiative_name})}

@router.post("/subscribe")
def subscribe(request: SubscribeRequest, Authorize: AuthJWT = Depends(),
              db: Session = Depends(get_db)):
    # Handle logged-in and un-logged-in subscriptions
    Authorize.jwt_optional()
    account = get_logged_in_user(Authorize, db)

    entity_type = request.entity_type
    db_model, field_lookup_fn = entity_type_map[entity_type]
    subscription_entity = db.query(db_model).filter_by(uuid=request.entity_uuid).first()
    if not subscription_entity:
        raise HTTPException(status_code=404,
                            detail="The requested {entity_type} cannot be found.")

    sub = Subscription(entity_type=SubscriptionEntity(entity_type),
                       entity_uuid=subscription_entity.uuid)

    if account:
        if request.identifier:
            logging.warning("Ignoring identifier in subscription for logged-in account.")
        identifier = account.primary_email_identifier

        existing_subscription = db.query(Subscription)\
                                  .filter_by(entity_type=SubscriptionEntity(entity_type))\
                                  .filter_by(entity_uuid=subscription_entity.uuid)\
                                  .filter_by(account_uuid=account.uuid).first()
        if existing_subscription:
            db.rollback()
            return {'uuid': sub.uuid}

        sub.identifier = identifier
        sub.verified = True
    elif request.identifier:
        _, identifier = get_or_create_identifier(
            request.identifier.type, request.identifier.identifier, db)
        entity_info = field_lookup_fn(subscription_entity)

        existing_subscription = db.query(Subscription)\
                                  .filter_by(entity_type=SubscriptionEntity(entity_type))\
                                  .filter_by(entity_uuid=subscription_entity.uuid)\
                                  .filter_by(identifier_uuid=identifier.uuid).first()
        if existing_subscription:
            db.rollback()
            return {'uuid': sub.uuid}

        # If the identifier has an account this subscription will be associated to the account,
        # but it still must be verified via email.
        sub.identifier = identifier

        token = VerificationToken()
        if not identifier.verified:
            token.personal_identifier = identifier
        token.subscription = sub
        db.add(token)
        db.commit()
        url = get_verification_url_for_token(token)
        message = create_subscription_verification_email(url,
                                                         entity_type,
                                                         entity_info['name'])
        notifications_manager.send_notification(
            identifier.value, message, NotificationChannel.EMAIL,
            title=f'Please verify your subscription with {Config["public_facing_org_name"]}')

    else:
        raise HTTPException(status_code=400, detail="No identifier provided")

    db.add(sub)
    db.commit()
    return {'uuid': sub.uuid}


@router.delete("/{uuid}")
def unsubscribe(uuid: str, request: UnsubscribeRequest, Authorize: AuthJWT = Depends(),
                db: Session = Depends(get_db)):
    Authorize.jwt_optional()
    account_uuid = Authorize.get_jwt_subject()

    if account_uuid:
        sub = db.query(Subscription).filter_by(uuid=uuid)\
                                    .filter_by(account_uuid=account_uuid).first()
        if sub:
            db.delete(sub)
            db.commit()
            return
    elif request.identifier:
        _, identifier = get_identifier(request.identifier.type,
                                       request.identifier.identifier, db)
        if identifier:
            sub = db.query(Subscription).filter_by(uuid=uuid)\
                                        .filter_by(identifier_uuid=identifier.uuid).first()
            if sub:
                db.delete(sub)
                db.commit()
                return

    else:
        raise HTTPException(
            status_code=400,
            detail="You must be logged in or provide an identifier to manage subscriptions.")

    raise HTTPException(status_code=404,
                        detail="Subscription not found")

@router.get("/account/{uuid}/initiatives")
def list_account_initiative_subscriptions(uuid: str, uuids_only: bool = False, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)

    return get_subscribed_initiatives_for_account(db, uuid, uuids_only)

def get_subscribed_initiatives_for_account(db, account_uuid, uuids_only=False):
    subscriptions = db.query(Subscription).filter_by(account_uuid=account_uuid)\
                                          .filter_by(entity_type=SubscriptionEntity('initiative'))\
                                          .filter_by(verified=True).all()
    if uuids_only:
        return [s.entity_uuid for s in subscriptions]

    initiatives = [db.query(Initiative).filter_by(uuid=s.entity_uuid).first() for s in subscriptions]
    return initiatives


@router.get("/account/{uuid}/initiative_map")
def get_account_initiative_map(uuid: str, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)

    subscribed_initiatives = set(get_subscribed_initiatives_for_account(db, uuid, uuids_only=True))
    all_initiatives = GetAllInitiatives(db)

    # map initiative_name: boolean is_subscribed
    return {i.initiative_name: i.uuid in subscribed_initiatives for i in all_initiatives}
