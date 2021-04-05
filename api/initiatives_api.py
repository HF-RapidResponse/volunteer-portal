from fastapi import Depends, FastAPI, Form, Request, HTTPException, Header, APIRouter
from models import NestedInitiative, Initiative, VolunteerEvent, VolunteerRole
from schemas import NestedInitiativeSchema, InitiativeSchema, VolunteerEventSchema, VolunteerRoleSchema
from typing import List, Optional
from settings import Config, Session, get_db
from sqlalchemy.orm import lazyload

router = APIRouter()

@router.get("/initiatives/", response_model=List[InitiativeSchema])
def get_all_initiatives(db: Session = Depends(get_db)) -> List[InitiativeSchema]:
    return GetAllInitiatives(db)


def GetAllInitiatives(db):
    return db.query(Initiative).options(lazyload(Initiative.roles_rel)).all()

def GetAllInitiativeNames(db):
    return db.query(Initiative.initiative_name).all()


@router.get("/initiatives/{initiative_external_id}", response_model=NestedInitiativeSchema)
def get_initiative_by_external_id(initiative_external_id, db: Session = Depends(get_db)) -> List[NestedInitiativeSchema]:
    return db.query(NestedInitiative).filter_by(external_id=initiative_external_id).first()
