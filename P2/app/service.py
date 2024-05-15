import psycopg2
from datetime import datetime

conn = psycopg2.connect(host='db', port=5432, user='postgres',
                        password='postgres', dbname='db')

def StartDb():
    # Database initialization logic here
    print("Database initialization completed successfully!")

def get_data():
    cur = conn.cursor()
    cur.execute('SELECT id, activity, todo_date, status FROM todolist')
    data = cur.fetchall()
    cur.close()
    return [{"id": row[0], "activity": row[1], "todo_date": row[2], "status": row[3]} for row in data]

def post_data(activity: str, date: datetime):
    cur = conn.cursor()
    cur.execute('INSERT INTO todolist (activity, todo_date, status) VALUES (%s, %s, TRUE)', (activity, date))
    conn.commit()
    cur.close()

def done(id: int):
    cur = conn.cursor()
    cur.execute("UPDATE todolist SET status = FALSE WHERE id = %s", (id,))
    conn.commit()
    cur.close()
