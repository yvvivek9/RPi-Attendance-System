import RPi.GPIO as GPIO
from mfrc522 import SimpleMFRC522
import base64

rfid = SimpleMFRC522()


async def write_to_rfid(content: str):
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
    while True:
        card_id, text = rfid.read()
        if text:
            encoded_bytes = str.encode(text)
            decoded_bytes = base64.b64decode(encoded_bytes)
            decoded_str = decoded_bytes.decode()
            return decoded_str
