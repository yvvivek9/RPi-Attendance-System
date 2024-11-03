import threading

from rpi.timetable import get_timetable
from rpi.attendance import take_attendance
from rpi.update import update_attendance


if __name__ == "__main__":
    print("Attendance server starting")
    get_timetable()
    t1 = threading.Thread(target=take_attendance)
    t2 = threading.Thread(target=update_attendance)
    t1.start()
    t2.start()
