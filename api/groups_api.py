from fastapi import Depends, FastAPI, Form, Request, HTTPException, Header, APIRouter
from fastapi_jwt_auth import AuthJWT
from models import Group, UserGroupRelation, Account
from schemas import GroupBaseSchema, GroupFullSchema, GroupRelation, AccountPublicBaseSchema, GroupStats
from typing import List, Optional
from settings import Config, Session, get_db
from sqlalchemy.orm import lazyload
from sqlalchemy import func
from helpers import row2dict

from account_api import check_matching_user

router = APIRouter()

@router.get("/", response_model=List[GroupBaseSchema])
def get_all_groups(db: Session = Depends(get_db)) -> List[GroupBaseSchema]:
    return db.query(Group).filter_by(approved_public=True).all()

@router.get("/{uuid}", response_model=GroupFullSchema)
def get_group(uuid, db: Session = Depends(get_db)) -> GroupBaseSchema:
    return db.query(Group).filter_by(uuid=uuid).filter_by(approved_public=True).first()

@router.get("/user/{uuid}", response_model=List[GroupRelation])
def get_groups_for_user(uuid, relationship_type=None, Authorize: AuthJWT = Depends(), db: Session = Depends(get_db)):
    Authorize.jwt_required()
    check_matching_user(uuid, Authorize)

    query = db.query(Group, UserGroupRelation).join(UserGroupRelation).filter(UserGroupRelation.user_id == uuid)
    if relationship_type:
        query = query.filter(UserGroupRelation.relationship == relationship_type)

    groups_rel_tups = query.all()

    for group, rel in groups_rel_tups:
        d = row2dict(group)
        d.update({"relationship": rel.relationship})
        yield d


@router.get("/{uuid}/admin", response_model=List[AccountPublicBaseSchema])
def get_admin_for_group(uuid, db: Session = Depends(get_db)):
    return db.query(Account).join(UserGroupRelation).filter(UserGroupRelation.group_id == uuid)\
                                                    .filter(UserGroupRelation.relationship == "ADMIN").all()

@router.get("/{uuid}/stats", response_model=GroupStats)
def get_stats_for_group(uuid, db: Session = Depends(get_db)):
    group = db.query(Group).filter_by(uuid=uuid).filter_by(approved_public=True).first()
    query = db.query(UserGroupRelation.relationship, func.count(UserGroupRelation.relationship)).filter(UserGroupRelation.group_id == uuid)
    result = query.group_by(UserGroupRelation.relationship).all()

    stats = {}
    for relationship, count in result:
        stats.update({f"{relationship.value.lower()}_count": count})

    result_dict = {'group': group, "stats": stats}

    return result_dict

@router.get("/close_to_zip/{zipcode}", response_model=List[GroupBaseSchema])
def get_closest_groups(zipcode, db: Session = Depends(get_db)):
    # faking this for now
    groups = db.query(Group).filter_by(approved_public=True).all()

    def get_zipnum(z):
        return int(z.strip().split("-")[0])

    def get_zip_distance(other_group):
        other_zip = other_group.zip_code
        return abs(get_zipnum(zipcode) - get_zipnum(other_zip))

    return sorted(groups, key=get_zip_distance)

# TODO
# create groups - use key for airtable - set up for airtable to use the api

# delete group

# is admin
# add admin
# delete admin
