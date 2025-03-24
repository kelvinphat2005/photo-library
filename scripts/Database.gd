extends Node

@export var db_path := "res://database/"
@export var db_name := "main"

var db_full_path : String
var db

var num_of_photos : int = 0

var album_template : Dictionary

# Called when the node enters the scene tree for the first time.
func create_database() -> void:
	db_full_path = db_path + db_name
	db = SQLite.new()
	db.path = db_full_path
	
	db.open_db()
	# Dictionary that contains most photo information
	var photos_dict := Dictionary()
	photos_dict["id"] = {"data_type": "int", "unique": true, "not_null": true, "primary_key": true}
	photos_dict["date"] = {"data_type": "text"}
	photos_dict["path"] = {"data_type": "text", "unique": true, "not_null": true}
	photos_dict["name"] = {"data_type": "text"}
	photos_dict["description"] = {"data_type": "text"}
	# photos_dict["tags"] = {"data_type": "text"}
	
	# Dictionary that contains tag information for quicker tag look up
	# EXAMPLE: A photo id is paired with a tag. It can have multiple instances of the same id
	var tags_dict_query = "CREATE TABLE 'tags' (
		'photo_id' INTEGER NOT NULL,
		'tag' TEXT NOT NULL,
		UNIQUE(photo_id,tag)
	);"
	#var tags_dict := Dictionary()
	#tags_dict["id"] = {"data_type": "int"}
	#tags_dict["tag"] = {"data_type": "text"}
	
	# Dictionary that contains album information
	var albums_dict := Dictionary()
	albums_dict["id"] = {"data_type": "int", "unique": true, "primary_key": true, "not_null": true}
	albums_dict["name"] = {"data_type": "text", "not_null": true}

	var album_photos_query = "CREATE TABLE 'album_photos' (
		'album_id' INTEGER NOT NULL,
		'photo_id' INTEGER NOT NULL,
		UNIQUE(album_id, photo_id)
	);"
	
	db.create_table("photos", photos_dict)
	db.query(tags_dict_query)
	db.create_table("albums", albums_dict)
	db.query(album_photos_query)
	db.close_db()

# add a photo to the database
func add_photo(path : String, name = null) -> void:
	print("[DB] add_photo():")
	var date = Time.get_date_string_from_system()
	# default name will be file name
	if name == null:
		# place holder
		name = "john_photo"
	var str_query = "INSERT INTO photos ('path', 'date', 'name', 'description') VALUES ('{path}', {date}, '{name}', '{description}')".format({
		"path": path, "date": date, "name":name, "description": ""
		})
	print(str_query)
	db.query(str_query)
	
	# TODO: PREVENT DUPLICATES

	PhotoLoader.db_changed = true
	
# give a photo a tag using it's ID
# input: list of strings
func add_tags(photo_id : int, tags : PackedStringArray) -> void:

	for tag in tags:
		
		var str_query = "INSERT INTO tags ('photo_id','tag') VALUES ('{id}','{tag}')".format({
			"id": photo_id, "tag": tag
			})
		print(str_query)
		db.query(str_query)
	

func get_photo_path(photo_id) -> String:
	var str_query = "SELECT path FROM photos WHERE id = {photo_id}".format({
		"photo_id": photo_id
		})
	print(str_query)
	db.query(str_query)
	var result = db.query_result
	print("RESULT: ", result)
	result = result[0]["path"]
	print(result)

	return result
	
func get_photo_info(photo_id):
	print("[DB, get_photo_info()] called")
	var str_query = "SELECT path FROM photos WHERE id = {photo_id}".format({
		"photo_id": photo_id
		})
	print(str_query)
	db.query(str_query)
	var result = db.query_result
	print("RESULT: ", result)
	result = result[0]
	print(result)

	return result

func get_photo(photo_id) -> Image:
	var path = get_photo_path(photo_id)
	var out = Image.load_from_file(path)
	return out

func make_photo(photo_id) -> PhotoTile:
	var p = Database.get_photo_info(photo_id)
	var new_photo_tile = PhotoTile.new(p.get_size().x, p.get_size().y, p["id"], p["path"])
	new_photo_tile.description = "" # placeholder
	new_photo_tile.photo_name = p["name"]
	new_photo_tile.tags = p["tags"]
	new_photo_tile.date = p["date"]
	return new_photo_tile

func create_album(album_name : String) -> void:
	var query = "INSERT INTO albums ('name') VALUES ('{album_name}')".format({
		"album_name": album_name
	})
	print("[DB, create_album()] query: ", query)
	db.query()

func add_to_album(album_id : int, photo_id : int) -> void:
	var query = "INSERT INTO album_photos ('album_id', 'photo_id') VALUES ('{album_id}', '{photo_id}'".format({
		"album_id": album_id, "photo_id": photo_id
	});
	print("[DB, add_to_album()] query: ", query)
	db.query()
