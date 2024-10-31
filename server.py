import asyncio

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import uvicorn
from dotenv import load_dotenv
import os

from app.config.database import check_database
from app.routes import auth, student, timetable

load_dotenv()

fastAPI = FastAPI()
fastAPI.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@fastAPI.get("/")
async def index_route():
    return FileResponse("client/artifacts/index.html")


fastAPI.include_router(auth.router, prefix="/api/auth", tags=["auth"])
fastAPI.include_router(student.router, prefix="/api/student", tags=["student"])
fastAPI.include_router(timetable.router, prefix="/api/timetable", tags=["timetable"])
fastAPI.mount("/", StaticFiles(directory="client/artifacts"), name="flutter")


if __name__ == "__main__":
    port = os.getenv('PORT')
    asyncio.run(check_database())
    # uvicorn.run("server:fastAPI", host="0.0.0.0", port=5000, reload=True)
    uvicorn.run("server:fastAPI", host="0.0.0.0", port=443, reload=True, ssl_certfile='certificates/cert.pem', ssl_keyfile='certificates/key.pem')
