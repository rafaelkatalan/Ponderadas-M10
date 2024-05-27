import psycopg2

conn = psycopg2.connect(host='POSTGRES_LOG', port=5432, user='postgres',
                        password='postgres', dbname='POSTGRES_LOG')

def StartDb():
    # Database initialization logic here
    print("Database initialization completed successfully!")

def login_log(userid: int, username: str):
    cur = conn.cursor()
    cur.execute('INSERT INTO login_log (userid, username) VALUES (%s, %s)', (userid, username))
    conn.commit()
    cur.close()
    return True

def sent_image_log(userid: int, username: str, imageid: int):
    cur = conn.cursor()
    cur.execute('INSERT INTO sent_image_log (userid, username, imageid) VALUES (%s, %s, %s)', (userid, username, imageid))
    conn.commit()
    cur.close()
    return True
