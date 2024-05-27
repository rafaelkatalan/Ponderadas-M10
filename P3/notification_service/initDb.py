import psycopg2
import time

time.sleep(5)

def StartDb():
    try:
        db = psycopg2.connect(host='POSTGRES_IMAGE', port=5432, user='postgres',
                              password='postgres', dbname='POSTGRES_IMAGE')
        cursor = db.cursor()

        cursor.execute('''
        CREATE TABLE IF NOT EXISTS IMAGES (
            ID SERIAL PRIMARY KEY,
            USER_ID INT,
            IMAGE VARCHAR,
            EDITED_IMAGE VARCHAR,
        );
        ''')
        
        db.commit()
        cursor.close()
        db.close()
        print("Database initialization completed successfully!")
    except psycopg2.Error as e:
        print("Error initializing database:", e)


