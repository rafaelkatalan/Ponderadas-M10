import psycopg2

def get_data():
    conn = psycopg2.connect(
        dbname='postgres',
        user='postgres',
        password='password',
        host='localhost',
        port='5432'
    )
    cur = conn.cursor()
    cur.execute('SELECT * FROM test')
    data = cur.fetchall()
    cur.close()
    conn.close()
    return data

def post_data(name:str, phone:str):
    conn = psycopg2.connect(
        dbname='postgres',
        user='postgres',
        password='password',
        host='localhost',
        port='5432'
    )
    cur = conn.cursor()
    cur.execute(f'INSERT INTO test (name, phone) VALUES ({name}, {phone})')
    conn.commit()
    cur.close()
    conn.close()
