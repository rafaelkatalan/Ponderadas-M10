import psycopg2
import numpy as np
import cv2
import base64

conn = psycopg2.connect(host='POSTGRES_USER', port=5432, user='postgres',
                        password='postgres', dbname='POSTGRES_USER')

def StartDb():
    # Database initialization logic here
    print("Database initialization completed successfully!")

def remove_background(image: str):
    try:
        image = base64.b64decode(image)
        nparr = np.frombuffer(image, np.uint8)
        image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        _, binary = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)
        contours, _ = cv2.findContours(binary, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        mask = cv2.drawContours(np.zeros_like(gray), contours, -1, (255), thickness=cv2.FILLED)
        result = cv2.bitwise_and(image, image, mask=mask)
        _, buffer = cv2.imencode('.jpg', result)
        image_base64 = base64.b64encode(buffer).decode('utf-8')
        return image_base64
    except Exception as e:
        print("Error removing background:", e)
        return None

def save_image(user_id: int, image: str, edited_image: str) -> bool:
    cur = conn.cursor()
    cur.execute('INSERT INTO IMAGES (USER_ID, IMAGE, EDITED_IMAGE) VALUES (%s, %s, %s)', (user_id, image, edited_image))
    conn.commit()
    cur.close()
    return True


def get_images(user_id: int):
    cur = conn.cursor()
    cur.execute('SELECT IMAGE, EDITED_IMAGE FROM IMAGES WHERE USER_ID = %s', (user_id,))
    images = cur.fetchall()
    cur.close()
    return images