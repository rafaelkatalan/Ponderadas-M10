from fastapi import FastAPI
from service import *
import asyncio
import uvicorn

app = FastAPI()

@app.get("/get")
async def read_root():
    return await get_data()

@app.post("/post")
async def read_root(name:str, phone:str):
    return await post_data(name, phone)

if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=80)