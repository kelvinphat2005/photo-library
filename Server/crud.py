import sqlite3, pathlib, shutil
from datetime import date
import cv2
from uuid import uuid4

# manages read and writes

from models import Photo, Tag, Album
from database import PHOTO_FOLDER_PATH

def get_photo_from_id(db : sqlite3.Connection, id : int) -> Photo:
    p = None

    db.row_factory = sqlite3.Row 
    cur = db.execute(
        "SELECT * FROM photos WHERE id = ?", (id,)
    )
    rows = cur.fetchall()
    print(rows[0])
    p = Photo(rows[0]["id"],rows[0]["name"],rows[0]["date"],rows[0]["description"],rows[0]["path"])

    return p

def add_photo(db : sqlite3.Connection, path : str, name : str = "", description : str = "") -> None:
    # duplicate photo
    shutil.copy(path, PHOTO_FOLDER_PATH)

    # get new relative path
    pathlb = pathlib.Path(path)
    file_name = pathlb.name
    rel_path = str(pathlib.Path(str(PHOTO_FOLDER_PATH) + "/" + str(file_name)).resolve())

    # get date
    dte = date.today()
    dte = dte.strftime("%Y%m%d")

    # add
    try:
        db.execute(
            "INSERT INTO photos (path, date, name, description) VALUES (?, ?, ?, ?)",
            (rel_path, dte, name, description),
        )
        db.commit()
    except:
        print("[CRUD.PY] Duplicate Photo Error")
    finally:
        return
    
def add_photo_img(db : sqlite3.Connection, img, name : str = "", description : str = "") -> None:
    if name == "":
        name = uuid4().hex
    rel_path = str(PHOTO_FOLDER_PATH) + "/" + str(name) + ".jpg"
    print("rel_path:", rel_path)
    cv2.imwrite(rel_path, img, [cv2.IMWRITE_JPEG_QUALITY, 90])
    
    # get date
    dte = date.today()
    dte = dte.strftime("%Y%m%d")

    # add
    try:
        db.execute(
            "INSERT INTO photos (date, path, name, description) VALUES (?, ?, ?, ?)",
            (dte, rel_path, name, description),
        )
        db.commit()
    except:
        print("[CRUD.PY] Duplicate Photo Error")
    finally:
        return
    
def photo_size(conn : sqlite3.Connection) -> int:
    cur = conn.cursor()
    cur.execute("SELECT COUNT(*) FROM photos")
    result = cur.fetchall()
    return result[0][0]