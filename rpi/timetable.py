import asyncio
import datetime
import json
import os

from app.config.database import get_database

FILE_PATH = os.path.join("rpi", "timetable.json")


def get_todays_day():
    today = datetime.date.today()
    name = today.strftime("%A")
    if name == "Sunday":
        # raise Exception("Today is a holiday")
        return "mon"
    elif name == "Monday":
        return "mon"
    elif name == "Tuesday":
        return "tue"
    elif name == "Wednesday":
        return "wed"
    elif name == "Thursday":
        return "thur"
    elif name == "Friday":
        return "fri"
    elif name == "Saturday":
        return "sat"
    else:
        raise Exception("Not found")
    

def store_timetable(tt: dict):
    with open(FILE_PATH, "w") as outfile: 
        json.dump(tt, outfile)
    

def get_timetable():
    dbo = asyncio.run(get_database())
    clc = dbo['timetable']
    res = clc.find_one({"day": get_todays_day()})
    if res:
        res["_id"] = ""
        store_timetable(res)
