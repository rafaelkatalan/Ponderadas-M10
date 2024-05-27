import psycopg2
import time

time.sleep(5)

def StartDb():
    try:
        db = psycopg2.connect(host='POSTGRES_LOG', port=5432, user='postgres',
                              password='postgres', dbname='POSTGRES_LOG')
        cursor = db.cursor()

        cursor.execute('''
        CREATE TABLE IF NOT EXISTS login_log (
            ID SERIAL PRIMARY KEY,
            userid INT,
            username VARCHAR(100),
            TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        CREATE TABLE IF NOT EXISTS sent_image_log (
            ID SERIAL PRIMARY KEY,
            userid INT,
            username VARCHAR(100),
            imageid INT,
            TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );
        ''')
        
        db.commit()
        cursor.close()
        db.close()
        print("Database initialization completed successfully!")
    except psycopg2.Error as e:
        print("Error initializing database:", e)


