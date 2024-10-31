from fastapi import APIRouter, HTTPException, Depends
import base64
import os
import random

from app.config.auth import verify_jwt
from app.utils.response import CustomResponse
from app.repos.student import *
# from app.utils.rfid import write_to_rfid
from open_cv.training import train

router = APIRouter()


@router.post('/add')
async def add_student_route(student: Student, auth=Depends(verify_jwt)) -> CustomResponse:
    check = await find_student_by_sid(student.std_id)
    if check:
        raise HTTPException(status_code=400, detail='Student ID already exists')
    await insert_student(student=student)
    return CustomResponse(detail='Student added successfully')


class SaveImageRequest(BaseModel):
    std_id: str
    image: str
    img_format: str


@router.post('/photos/save')
async def save_student_photo_route(request: SaveImageRequest, auth=Depends(verify_jwt)) -> CustomResponse:
    image_as_bytes = str.encode(request.image)
    img_recovered = base64.b64decode(image_as_bytes)
    img_name = request.std_id + '.' + str(random.randint(100, 1000000)) + '.' + request.img_format
    img_path = os.path.join('open_cv', 'photos', img_name)
    with open(img_path, "wb") as f:
        f.write(img_recovered)
    return CustomResponse(detail='Image saved')


class SaveRFIDRequest(BaseModel):
    std_id: str


@router.post('/rfid/save')
async def save_to_rfid(request: SaveRFIDRequest, auth=Depends(verify_jwt)) -> CustomResponse:
    # response = await write_to_rfid(request.std_id)
    # if response:
    #     return CustomResponse(detail='RFID written')
    # else:
    #     raise HTTPException(status_code=400, detail='Failed to write to RFID')
    print(request.std_id)


@router.post('/train')
async def train_model_route(auth=Depends(verify_jwt)) -> CustomResponse:
    train()
    return CustomResponse(detail='Training complete')


@router.post('/list')
async def list_students_route(auth=Depends(verify_jwt)) -> List[Student]:
    return await list_students()
