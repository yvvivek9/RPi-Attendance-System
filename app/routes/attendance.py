from fastapi import APIRouter, HTTPException, Depends
from typing import List

from app.config.auth import verify_jwt
from app.repos.attendance import *

router = APIRouter()


@router.post('/list')
async def list_attendance_route(auth=Depends(verify_jwt)) -> List[Attendance]:
    return await list_attendance()
