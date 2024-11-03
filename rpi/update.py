import json
import os
import time
import asyncio
import signal
from datetime import datetime

from app.config.database import get_database
from rpi.attendance import load_present, save_present

FILE_PATH = os.path.join("rpi", "timetable.json") 


def load_timetable() -> dict:
    try:
        with open(FILE_PATH, "r") as file:
            data = json.load(file)
            return dict(data)
    except:
        time.sleep(1)
        return load_timetable()
    

def time_lesser_than_now(time: str) -> bool:
    hour, minute = time.split(":")
    now = datetime.now()
    now_str = datetime.strftime(now, '%H:%M')
    now_hour, now_minute = str.split(now_str, ':')
    if now_hour > hour and now_minute > minute:
        return True
    else:
        return False
    

def get_period() -> str:
    timetable = load_timetable()
    if time_lesser_than_now(timetable["p8"][1]):
        return "Period 8"
    if time_lesser_than_now(timetable["p7"][1]):
        return "Period 7"  
    if time_lesser_than_now(timetable["p6"][1]):
        return "Period 6"  
    if time_lesser_than_now(timetable["p5"][1]):
        return "Period 5"
    if time_lesser_than_now(timetable["p4"][1]):
        return "Period 4"
    if time_lesser_than_now(timetable["p3"][1]):
        return "Period 3"
    if time_lesser_than_now(timetable["p2"][1]):
        return "Period 2"
    if time_lesser_than_now(timetable["p1"][1]):
        return "Period 1"


def update_attendance():
    while True:
        time.sleep(10)
        period = get_period()
        date = datetime.now().strftime("%d-%m-%Y")

        if period:
            dbo = asyncio.run(get_database())
            clc = dbo["attendance"]
            exist = clc.find_one({
                "date": date,
                "period": period
            })
            if not exist:
                clc.insert_one({
                    "date": date,
                    "period": period,
                    "present": load_present()
                })
                print("Attendance updated")

            if period == "Period 8":
                save_present([])
                # os.kill(os.getpid(), signal.SIGINT)
