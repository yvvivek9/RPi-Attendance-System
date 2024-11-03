import cv2
import os
import time
from picamera2 import Picamera2

# Initialize face detector and face recognizer
faceDetect = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
rec = cv2.face.LBPHFaceRecognizer_create()
rec.read(os.path.join("open_cv", "trainingData.yml"))

# Initialize the Pi camera
picam2 = Picamera2()
camera_config = picam2.create_preview_configuration(main={"format": "RGB888", "size": (640, 480)})
picam2.configure(camera_config)


def check_face_id(target_face_id: str, timeout: int = 10) -> bool:
    picam2.start()
    start_time = time.time()

    while time.time() - start_time < timeout:
        img = picam2.capture_array()
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        faces = faceDetect.detectMultiScale(gray, 1.3, 5)
        
        for (x, y, w, h) in faces:
            face_id, conf = rec.predict(gray[y:y + h, x:x + w])
            if str(face_id) == target_face_id:
                picam2.stop()
                return True
    
    picam2.stop()
    return False
