from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
import subprocess

from app.routes import auth, student, timetable, attendance


fastAPI = FastAPI()
fastAPI.server_process = subprocess.Popen([
        "/home/pi4/Desktop/RPi-Attendance-System/.venv/bin/python",
        "/home/pi4/Desktop/RPi-Attendance-System/system.py"
    ])
fastAPI.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


@fastAPI.get("/")
async def index_route():
    return FileResponse("client/artifacts/index.html")


@fastAPI.post("/system/stop")
async def stop_system_route():
    fastAPI.server_process.terminate()


@fastAPI.post("/system/start")
async def start_system_route():
    fastAPI.server_process = subprocess.Popen([
        "/home/pi4/Desktop/RPi-Attendance-System/.venv/bin/python",
        "/home/pi4/Desktop/RPi-Attendance-System/system.py"
    ])


fastAPI.include_router(auth.router, prefix="/api/auth", tags=["auth"])
fastAPI.include_router(student.router, prefix="/api/student", tags=["student"])
fastAPI.include_router(timetable.router, prefix="/api/timetable", tags=["timetable"])
fastAPI.include_router(attendance.router, prefix="/api/attendance", tags=["attendance"])
fastAPI.mount("/", StaticFiles(directory="client/artifacts"), name="flutter")
    