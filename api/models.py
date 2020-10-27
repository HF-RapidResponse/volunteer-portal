from pydantic import BaseModel
from typing import Optional
from enum import Enum

Url = str
MarkdownText = str

class Person(BaseModel):
    name: str

class Priority(Enum):
    TOP_PRIORITY = 'top_priority'
    HIGH = 'high'
    MEDIUM = 'medium'
    LOW = 'low'

class VolunteerRole(BaseModel):
    position_id: str
    hero_image_url: Url
    priority: Priority
    signup_url: Url
    hrff_team_lead: Optional[Person]
    num_openings: int
    min_weekly_time_commitment: int
    max_weekly_time_commitment: int
    overview: MarkdownText
    what_you_will_learn: MarkdownText
    responsibilites: MarkdownText
    qualifications: MarkdownText
