import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
import base64
import asyncio
import time


async def write_to_rfid(content: str):
    rfid = SimpleMFRC522()
    try:
        content_bytes = str.encode(content)
        content_encoded = base64.b64encode(content_bytes)
        content_final = content_encoded.decode()
        rfid.write(content_final)
        GPIO.cleanup()
        return True
    finally:
        GPIO.cleanup()


async def read_from_rfid() -> str:
    rfid = SimpleMFRC522()
    while True:
        time.sleep(1)
        card_id, text = rfid.read()
        if text:
            encoded_bytes = str.encode(text)
            decoded_bytes = base64.b64decode(encoded_bytes)
            decoded_str = decoded_bytes.decode()
            print(decoded_str)
            return decoded_str
        

if __name__ == '__main__':
    # write = asyncio.run(write_to_rfid('Get out'))
    # time.sleep(2)
    reply = asyncio.run(read_from_rfid())
    print(reply)


