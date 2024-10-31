from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import time
import jwt
import os

JWT_SECRET = os.getenv('JWT_SECRET')
JWT_ALGORITHM = os.getenv('JWT_ALGORITHM')
JWT_VALIDITY = os.getenv('JWT_VALIDITY')  # in seconds


async def sign_jwt() -> str:
    payload = {
        "content": "sample",
        "expires": time.time() + float(JWT_VALIDITY)
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)


async def verify_jwt(security: HTTPAuthorizationCredentials = Depends(HTTPBearer(scheme_name='Bearer'))) -> bool:
    try:
        decoded = jwt.decode(security.credentials, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        if decoded["expires"] >= time.time():
            return True
        else:
            raise HTTPException(status_code=401, detail="Authorization expired")
    except Exception as e:
        print(f"Error verifying JWT: {e}")
        raise HTTPException(status_code=401, detail="Invalid authentication")
