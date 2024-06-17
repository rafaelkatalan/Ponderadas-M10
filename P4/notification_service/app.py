from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from datetime import datetime
from typing import List
import uvicorn
from initDb import StartDb
from service import remove_background, save_image, get_images
from fastapi import UploadFile

StartDb()

app = FastAPI()

class Image(BaseModel):
    Image: str
    userId: int
    

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust this to restrict domains in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.post("/upload_image")
def upload_image(image: Image):
    edited_image = remove_background(image.Image)
    save_image(image.userId, image.Image, edited_image)
    if edited_image is None:
        raise HTTPException(status_code=500, detail="Error processing image")
    return {"message": "Image processed successfully"}

@app.get("/get_images/{userId}")
def getImages(userId: int):
   return get_images(userId)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8002)
