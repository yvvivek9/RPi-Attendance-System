from pydantic import BaseModel, Field
from typing import List, Optional
from bson.objectid import ObjectId

from app.config.database import get_database

COLLECTION_NAME = "attendance"


class Attendance(BaseModel):
    id: Optional[str] = Field(None, alias="_id")
    date: str
    period: str
    present: List[str]

    def __init__(self, **data):
        if '_id' in data and isinstance(data['_id'], ObjectId):
            data['_id'] = str(data['_id'])
        super().__init__(**data)


async def list_attendance() -> List[Attendance]:
    db = await get_database()
    clc = db[COLLECTION_NAME]
    result = clc.find()
    ret_list = []
    for r in result:
        ret_list.append(Attendance(**r))
    return ret_list
