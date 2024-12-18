import os
import asyncio
import uvicorn
import socket
import time
from dotenv import load_dotenv

from app.config.database import check_database
from rpi.lcd_display import write_text


while True:  # Check for internet
    try:
        time.sleep(5)
        socket.setdefaulttimeout(5)
        print('Trying network')
        socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect(("8.8.8.8", 53))
        print('Network connected')
        break
    except:
        print('Network not connected')


load_dotenv()
port = os.getenv('PORT')
asyncio.run(check_database())
write_text('Server starting')
# uvicorn.run("server:fastAPI", host="0.0.0.0", port=5000)
uvicorn.run("server:fastAPI", host="0.0.0.0", port=443, ssl_certfile=os.path.join('certificates', 'cert.pem'), ssl_keyfile=os.path.join('certificates', 'key.pem'))

# sudo /home/pi4/Desktop/RPi-Attendance-System/.venv/bin/python /home/pi4/Desktop/RPi-Attendance-System/run.py
