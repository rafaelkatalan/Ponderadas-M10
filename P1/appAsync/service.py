import psycopg2

async def get_data():
    conn = psycopg2.connect(
        dbname='postgres',
        user='postgres',
        password='password',
        host='localhost',
        port='5432'
    )
    cur = conn.cursor()
    cur.execute('SELECT * FROM test')
    data = await cur.fetchall()
    cur.close()
    conn.close()
    return data

async def post_data(name:str, phone:str):
    conn = psycopg2.connect(
        dbname='postgres',
        user='postgres',
        password='password',
        host='localhost',
        port='5432'
    )
    cur = conn.cursor()
    await cur.execute(f'INSERT INTO test (name, phone) VALUES ({name}, {phone})')
    conn.commit()
    cur.close()
    conn.close()
