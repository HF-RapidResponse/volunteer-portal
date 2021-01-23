from enum import Enum

class Priority(Enum):
    TOP_PRIORITY = 'Top Priority'
    HIGH = 'high'
    MEDIUM = 'medium'
    LOW = 'low'
    COULD_BE_NICE = 'Could Be Nice'
    NONE = None
