from pydantic import BaseModel, Field
from typing import List, Optional
from bson.objectid import ObjectId

from app.config.database import get_database

COLLECTION_NAME = "students"


class Student(BaseModel):
    id: Optional[str] = Field(None, alias="_id")
    name: str
    std_id: str
    std_class: str | None

    def __init__(self, **data):
        if '_id' in data and isinstance(data['_id'], ObjectId):
            data['_id'] = str(data['_id'])
        super().__init__(**data)


async def insert_student(student: Student):
    db = await get_database()
    clc = db[COLLECTION_NAME]
    value = student.model_dump(by_alias=True)
    value.pop("_id")
    clc.insert_one(value)


async def find_student_by_sid(sid: str) -> Optional[Student]:
    db = await get_database()
    clc = db[COLLECTION_NAME]
    query = {"std_id": sid}
    res = clc.find_one(query)
    if res:
        return Student(**res)
    return None


async def list_students() -> List[Student]:
    db = await get_database()
    clc = db[COLLECTION_NAME]
    result = clc.find()
    ret_list = []
    for r in result:
        ret_list.append(Student(**r))
    return ret_list


async def update_student(sid: str, student: Student):
    db = await get_database()
    clc = db[COLLECTION_NAME]
    query = {"std_id": sid}
    value = student.model_dump(by_alias=True)
    value.pop('_id')
    clc.update_one(query, {"$set": value})


async def delete_hospital_by_sid(sid: str):
    db = await get_database()
    clc = db[COLLECTION_NAME]
    query = {"std_id": sid}
    clc.delete_one(query)

