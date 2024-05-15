import psycopg2
import time

time.sleep(5)

def StartDb():
    try:
        db = psycopg2.connect(host='db', port=5432, user='postgres',
                              password='postgres', dbname='db')
        cursor = db.cursor()

        cursor.execute('''
        CREATE TABLE IF NOT EXISTS todolist (
            id SERIAL PRIMARY KEY,
            activity VARCHAR(100),
            todo_date DATE,
            status BOOLEAN
        );
        ''')
        
        db.commit()
        cursor.close()
        db.close()
        print("Database initialization completed successfully!")
    except psycopg2.Error as e:
        print("Error initializing database:", e)

StartDb()
