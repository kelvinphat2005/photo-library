from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import FileResponse
import os
from database import init_db, get_conn, DATABASE_PATH
import crud, models
import sqlite3
import pathlib
from uuid import uuid4
from typing import Annotated
from PIL import Image, UnidentifiedImageError 
import cv2
import pathlib


TEMP_FOLDER = pathlib.Path(__file__).with_name("temp")

ALLOWED_TYPES = {"image/png", "image/jpeg"}

app = FastAPI()
init_db()

def db_dep() -> sqlite3.Connection:
    return get_conn()

@app.get("/")
def root():
    return {"Hello":"World"}

@app.post("/upload")
async def add_photo(photo : UploadFile = File(...)):
    tmp_path = TEMP_FOLDER / f"{uuid4().hex}"
    extension = pathlib.Path(photo.filename).suffix.lower()
    print(extension)
    
    if not photo.filename:
        raise HTTPException(400, "No filename supplied")
    if extension not in {".png", ".jpg", ".jpeg"}:
        raise HTTPException(400, f"Unsupported extension {extension!r}")

    with tmp_path.open("wb") as buffer:
        while chunk := await photo.read(1 << 14):   # 16 KiB
            buffer.write(chunk)

    img = cv2.imread(str(tmp_path), cv2.IMREAD_UNCHANGED)
    if img is None:
        raise ValueError("Not a valid image")

    with sqlite3.connect(DATABASE_PATH) as db:
        crud.add_photo_img(db, img, extension)

    return {"test": "testing"}

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