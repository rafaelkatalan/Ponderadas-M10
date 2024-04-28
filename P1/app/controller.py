from fastapi import FastAPI
from service import *
import uvicorn

app = FastAPI()

@app.get("/get")
def read_root():
    return get_data()

@app.post("/post")
def read_root(name:str, phone:str):
    return post_data(name, phone)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)