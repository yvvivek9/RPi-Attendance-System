import os
import asyncio
from typing import List
import time

from app.utils.rfid import read_from_rfid
import open_cv.predict_pi as predict_pi
from rpi.lcd_display import write_text


FILE_PATH = os.path.join("rpi", "present.txt")


def load_present() -> List[str]:
    try:
        with open(FILE_PATH, 'r') as file:
            content = file.read()
            ct_list = content.split(',')
            return ct_list if ct_list != [''] else []
    except:
        time.sleep(1)
        return load_present()
    

def save_present(present: List[str]):
    try:
        with open(FILE_PATH, 'w') as file:
            file.write(','.join(present))
    except:
        time.sleep(1)
        save_present(present)


def take_attendance():
    while True:       
        time.sleep(2)
        write_text("Place card", "on the reader")
        student_id = asyncio.run(read_from_rfid()) # Holds for 1 sec
        write_text("RFID scanned")
        verified = predict_pi.check_face_id(student_id)
        if verified == True:
            write_text("FaceID scanned")
            time.sleep(1)
            presents = load_present()
            if student_id in presents:
                presents.remove(student_id)
                write_text("Check-out", "successful")
            else:
                presents.append(student_id)
                write_text("Check-in", "successful")
            save_present(present=presents)
        else:
            write_text("Invalid FaceID")


