import sqlite3, pathlib, contextlib

DATABASE_PATH = pathlib.Path(__file__).with_name("photos.db")
PHOTO_FOLDER_PATH = pathlib.Path(__file__).with_name("photos")

def get_conn() -> sqlite3.Connection:
    conn = sqlite3.connect(DATABASE_PATH)
    return conn

def init_db() -> None:
    with sqlite3.connect(DATABASE_PATH) as conn:
        cur = conn.cursor()
        # photos table
        cur.execute("""
            CREATE TABLE IF NOT EXISTS photos (
                id          INTEGER PRIMARY KEY NOT NULL,
                date        TEXT,
                path        TEXT UNIQUE NOT NULL,
                name        TEXT,
                description TEXT
            );
        """)

        # tags table
        cur.execute("""
            CREATE TABLE IF NOT EXISTS tags (
                photo_id INTEGER NOT NULL,
                tag      TEXT    NOT NULL,
                UNIQUE(photo_id, tag)
            );
        """)

        # album_photos table
        cur.execute("""
            CREATE TABLE IF NOT EXISTS album_photos (
                album_id INTEGER NOT NULL,
                photo_id INTEGER NOT NULL,
                UNIQUE(album_id, photo_id)
            );
        """)


