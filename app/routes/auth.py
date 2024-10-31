from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel

from app.config.auth import sign_jwt, verify_jwt
from app.utils.response import CustomResponse, LoginResponse

router = APIRouter()


class LoginRequestBody(BaseModel):
    username: str
    password: str


@router.post('/login')
async def login_route(request: LoginRequestBody) -> LoginResponse:
    if request.username == 'admin' and request.password == 'admin':
        token = await sign_jwt()
        return LoginResponse(token=token)
    else:
        raise HTTPException(status_code=400, detail='Invalid authentication')


@router.post('/check')
async def check_route(auth: bool = Depends(verify_jwt)) -> CustomResponse:
    return CustomResponse(detail='Authentication valid')
