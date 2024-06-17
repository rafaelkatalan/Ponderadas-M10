from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime
from typing import List
import uvicorn
from initDb import StartDb
from service import create_user, login

StartDb()

app = FastAPI()

class User(BaseModel):
    name: str
    password: str

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this to restrict domains in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/newUser")
def New_User(User: User):
    create_user(User.name, User.password)
    return {"message": "User added successfully"}

@app.post("/login")
def Login(user: User):
    id = login(user.name, user.password)
    if id!=-1:
        return id
    else:
        raise HTTPException(status_code=401, detail="Invalid credentials")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
