import cv2
import os
import numpy as np
from PIL import Image

faceDetect = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
recognizer = cv2.face.LBPHFaceRecognizer_create()
photos_path = os.path.join('open_cv', 'photos')


def load_faces():
    image_paths = [os.path.join(photos_path, f) for f in os.listdir(photos_path)]
    images = []
    face_ids = []

    for path in image_paths:
        image = Image.open(path).convert('L')
        img_np = np.array(image, 'uint8')
        faces = faceDetect.detectMultiScale(img_np, 1.3, 5)
        for (x, y, w, h) in faces:  # Crop and append the face region
            face = img_np[y:y+h, x:x+w]
            images.append(face)
        face_id = os.path.split(path)[-1].split('.')[0]
        face_ids.append(int(face_id))

    return np.array(face_ids), images


def train():
    face_ids, images = load_faces()
    yml_path = os.path.join('open_cv', 'trainingData.yml')
    if os.path.exists(yml_path):
        recognizer.read(yml_path)
        recognizer.update(images, face_ids)
    else:
        recognizer.train(images, face_ids)
    recognizer.write(yml_path)


# if __name__ == "__main__":
#     train()
#     cv2.destroyAllWindows()
