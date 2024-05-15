from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime
from typing import List
import uvicorn
from initDb import StartDb
from service import get_data, post_data, done

StartDb()

app = FastAPI()

class Task(BaseModel):
    activity: str
    date: datetime

class DoneTask(BaseModel):
    id: int

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this to restrict domains in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/read", response_model=List[dict])
def read_root():
    return get_data()

@app.post("/add")
def add_task(task: Task):
    post_data(task.activity, task.date)
    return {"message": "Task added successfully"}

@app.post("/done")
def mark_done(task: DoneTask):
    done(task.id)
    return {"message": "Task marked as done"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
