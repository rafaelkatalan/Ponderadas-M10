import psycopg2

conn = psycopg2.connect(host='POSTGRES', port=5432, user='postgres',
                        password='postgres', dbname='POSTGRES')

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

def save_nginx_log(log_data: dict):
    cur = conn.cursor()
    cur.execute("""
        INSERT INTO nginx_log (remote_addr, remote_user, time_local, request, status, body_bytes_sent, http_referer, http_user_agent, http_x_forwarded_for)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (
        log_data.get('remote_addr'),
        log_data.get('remote_user'),
        log_data.get('time_local'),
        log_data.get('request'),
        log_data.get('status'),
        log_data.get('body_bytes_sent'),
        log_data.get('http_referer'),
        log_data.get('http_user_agent'),
        log_data.get('http_x_forwarded_for')
    ))
    conn.commit()
    cur.close()
    return True
