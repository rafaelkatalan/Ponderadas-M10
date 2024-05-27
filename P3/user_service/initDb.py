import psycopg2
import time

time.sleep(5)

def StartDb():
    try:
        db = psycopg2.connect(host='POSTGRES_USER', port=5432, user='postgres',
                              password='postgres', dbname='POSTGRES_USER')
        cursor = db.cursor()

        cursor.execute('''
        CREATE TABLE IF NOT EXISTS USERS (
            ID SERIAL PRIMARY KEY,
            NAME VARCHAR(100),
            PASSWORD VARCHAR,
            CREATE_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        ''')
        
        db.commit()
        cursor.close()
        db.close()
        print("Database initialization completed successfully!")
    except psycopg2.Error as e:
        print("Error initializing database:", e)


