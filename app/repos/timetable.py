from pydantic import BaseModel, Field
from typing import List, Optional
from bson.objectid import ObjectId

from app.config.database import get_database

COLLECTION_NAME = "timetable"


class Timetable(BaseModel):
    id: Optional[str] = Field(None, alias="_id")
    day: str
    p1: List[str]
    p2: List[str]
    p3: List[str]
    p4: List[str]
    p5: List[str]
    p5: List[str]
    p6: List[str]
    p7: List[str]
    p8: List[str]

    def __init__(self, **data):
        if '_id' in data and isinstance(data['_id'], ObjectId):
            data['_id'] = str(data['_id'])
        super().__init__(**data)


async def get_period_time(day: str, period: str) -> List[str]:
    db = await get_database()
    clc = db[COLLECTION_NAME]
    query = {"day": day}
    res = clc.find_one(query)
    if res:
        return res[period]


async def update_period_time(day: str, data: dict):
    db = await get_database()
    clc = db[COLLECTION_NAME]
    query = {"day": day}
    clc.update_one(query, {'$set': data})
