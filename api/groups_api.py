from fastapi import Depends, FastAPI, Form, Request, HTTPException, Header, APIRouter
from models import Group
from schemas import GroupBaseSchema, GroupFullSchema
from typing import List, Optional
from settings import Config, Session, get_db
from sqlalchemy.orm import lazyload

router = APIRouter()

@router.get("/", response_model=List[GroupBaseSchema])
def get_all_groups(db: Session = Depends(get_db)) -> List[GroupBaseSchema]:
    return db.query(Group).filter_by(approved_public=True).all()
