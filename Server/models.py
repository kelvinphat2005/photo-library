class Photo():
    __tablename__ = "photo"

    def __init__(self, id: int, name: str, date: str, description: str, path: str):
        self.id = id
        self.name = name
        self.date = date
        self.description = description
        self.path = path

    def __str__(self):
        s = f"id: {self.id}\nname: {self.name}\ndate created: {self.date}\ndescription: {self.description}\npath: {self.path}"
        return s

class Album():
    __tablename__ = "albums"

    def __init__(self, id: int, name: str):
        self.id = id
        self.name = name

class Tag():
    __tablename__ = "tags"

    def __init__(self, photo_id: int, tag: str):
        self.photo_id = photo_id
        self.tag = tag