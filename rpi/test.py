import time
from datetime import datetime

hour = '00'
minute = '50'

while True:
    time.sleep(5)
    now = datetime.now()
    now_str = datetime.strftime(now, '%H:%M')
    now_hour, now_minute = str.split(now_str, ':')
    if hour == now_hour and minute == now_minute:
        print('Time is equal')
