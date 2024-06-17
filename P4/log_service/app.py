from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime
import uvicorn
from initDb import StartDb
from service import login_log, sent_image_log, save_nginx_log
import json

StartDb()

app = FastAPI()

class User(BaseModel):
    name: str
    id: int

class ImageAction(BaseModel):
    username: str
    Userid: int
    imageid: int

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this to restrict domains in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/login_log")
def LoginLog(User: User):
    login_log(User.id, User.name)
    return True

@app.post("/image_log")
def ImageLog(imageAction: ImageAction):
    sent_image_log(imageAction.Userid, imageAction.username, imageAction.imageid)
    return True

@app.post("/nginx_log")
async def NginxLog(request: Request):
    log_data = await request.json()
    save_nginx_log(log_data)
    return {"status": "success"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
