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
	var photos_dict := Dictionary()
	photos_dict["id"] = {"data_type": "int", "unique": true, "not_null": true, "primary_key": true}
	photos_dict["date"] = {"data_type": "text"}
	photos_dict["path"] = {"data_type": "text", "unique": true, "not_null": true}
	photos_dict["name"] = {"data_type": "text"}
	photos_dict["tags"] = {"data_type": "text"}
	
	var albums_dict := Dictionary()
	albums_dict["name"] = {"data_type": "text", "not_null": true}
	albums_dict["album_id"] = {"data_type": "int", "unique": true, "not_null": true, "primary_key": true}
	
	album_template["photo_id"] = {"data_type": "int", "unique": true, "not_null": true}
	
	db.create_table("photos", photos_dict)
	db.create_table("albums", albums_dict)
	db.close_db()

# add a photo to the database
func add_photo(path : String, name = null) -> void:
	var date = Time.get_date_string_from_system()
	# default name will be file name
	if name == null:
		# place holder
		name = "john_photo"
	var str_query = "INSERT INTO photos ('path', 'date', 'name', 'tags') VALUES ('{path}', {date}, '{name}', '')".format({
		"path": path, "date": date, "name":name
		})
	print(str_query)
	db.query(str_query)
	
	PhotoLoader.db_changed = true
	
# give a photo a tag using it's ID
# input: list of strings
func add_tags(photo_id : int, tags : PackedStringArray) -> void:
	
	var tags_to_string = ""
	for tag in tags:
		tags_to_string = tags_to_string + tag + ","
	
	var str_query = "UPDATE photos SET tags = tags || '{tags_to_string}' WHERE id = {photo_id}".format({
		"tags_to_string": tags_to_string, "photo_id": photo_id
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

func get_photo(photo_id) -> Image:
	var path = get_photo_path(photo_id)
	var out = Image.load_from_file(path)
	return out

func make_photo(photo_id) -> Photo:
	var p = Database.get_photo(photo_id)
	return Photo.new(p.get_size().x, p.get_size().y, photo_id, get_photo_path(photo_id))
