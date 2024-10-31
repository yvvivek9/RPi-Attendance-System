from fastapi import APIRouter, HTTPException, Depends

from app.config.auth import verify_jwt
from app.utils.response import CustomResponse
from app.repos.timetable import *

router = APIRouter()


class GetPeriodTimeRequest(BaseModel):
    day: str
    period: str


@router.post('/period/get')
async def get_timetable_by_day_route(request: GetPeriodTimeRequest, auth=Depends(verify_jwt)) -> List[str]:
    return await get_period_time(request.day, request.period)


class UpdatePeriodTimeRequest(BaseModel):
    day: str
    period: str
    start: str
    end: str


@router.post('/period/update')
async def update_period_timing_route(request: UpdatePeriodTimeRequest, auth=Depends(verify_jwt)) -> CustomResponse:
    await update_period_time(request.day, {request.period: [request.start, request.end]})
    return CustomResponse(detail='Timings changed successfully')
