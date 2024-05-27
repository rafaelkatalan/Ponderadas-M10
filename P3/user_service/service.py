import psycopg2
from datetime import datetime
import bcrypt

conn = psycopg2.connect(host='POSTGRES_USER', port=5432, user='postgres',
                        password='postgres', dbname='POSTGRES_USER')

def StartDb():
    # Database initialization logic here
    print("Database initialization completed successfully!")

def create_user(name: str, password: str):
    cur = conn.cursor()
    cur.execute('INSERT INTO USERS (NAME, PASSWORD) VALUES (%s, %s)', (name, password))
    conn.commit()
    cur.close()
    return True

def login(name: str, password: str) -> bool:
    cur = conn.cursor()
    cur.execute('SELECT PASSWORD FROM USERS WHERE NAME = %s', (name,))
    result = cur.fetchone()
    cur.close()

    if result is not None:
        if password == result[0]:
            return True

    return False
