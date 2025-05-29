from fastapi import FastAPI
from fastapi.responses import FileResponse
import os
from database import init_db, get_conn, DATABASE_PATH
import crud, models
import sqlite3
from typing import Annotated

app = FastAPI()
init_db()

def db_dep() -> sqlite3.Connection:
    return get_conn()

@app.get("/")
def root():
    return {"Hello":"World"}

@app.post("/photos")
def add_photo(photo_path : str):
    with sqlite3.connect(DATABASE_PATH) as db:
        crud.add_photo(db, photo_path)

@app.get("/photos/{photo_id}")
def get_photo(photo_id : int):
    with sqlite3.connect(DATABASE_PATH) as db:
        photo = crud.get_photo_from_id(db, photo_id)
        file_path = photo.path
        print("File Path:", file_path)
        return FileResponse(file_path, media_type="image/jpeg")
    
@app.get("/test/{id}")
def test(id : int):
    return {"penid": id}