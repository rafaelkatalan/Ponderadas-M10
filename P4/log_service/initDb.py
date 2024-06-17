import psycopg2
import time

time.sleep(5)

def StartDb():
    try:
        db = psycopg2.connect(host='POSTGRES', port=5432, user='postgres',
                              password='postgres', dbname='POSTGRES')
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
        CREATE TABLE nginx_log (
            id SERIAL PRIMARY KEY,
            remote_addr VARCHAR(45),
            remote_user VARCHAR(255),
            time_local TIMESTAMP,
            request TEXT,
            status INT,
            body_bytes_sent BIGINT,
            http_referer TEXT,
            http_user_agent TEXT,
            http_x_forwarded_for TEXT
        );
        ''')
        
        db.commit()
        cursor.close()
        db.close()
        print("Database initialization completed successfully!")
    except psycopg2.Error as e:
        print("Error initializing database:", e)


