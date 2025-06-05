extends Node

var photos : Array = []
var photo_queue : Array =[]

# tracking whether to load more images
var active : bool = false
var first_launch : bool = true
var db_changed : bool = false

var num_of_photos_on_launch : int

var curr_id : int = -1

# connections
var connection : DatabaseConnection
const SAVE_DIR := "user://photos"

# slow down process
var tick_rate := 2
@onready var ticker := Timer.new()

func _ready() -> void:
	# create /photos/ folder in user directory (in appdata)
	DirAccess.open("user://").make_dir_recursive(SAVE_DIR)
	
	# create timer for tickrate
	ticker.wait_time = 1.0 / tick_rate
	ticker.autostart = true
	ticker.one_shot = false
	add_child(ticker)
	ticker.timeout.connect(_on_tick)
	
	if Global.connect_to_api:
		connection = ServerConnection.new()
		num_of_photos_on_launch = await ApiRequest.get_photo_size()
		active = true
	else:
		connection = LocalConnection.new()
		

func _on_tick() -> void:
	
	if active:
		# only load ALL photos at beginning
		if first_launch:
			var result = []
			if not Global.connect_to_api:
				var str_query = "SELECT * FROM photos"
				print("[PHOTO LOADER] str_query: ", str_query)
				Database.db.query(str_query)
				result = Database.db.query_result
				print(result)
			else:
				print("[PHOTO LOADER] API, num of photos on launch: ", num_of_photos_on_launch)
				for id in range(1, num_of_photos_on_launch + 1):
					var bytes = await ApiRequest.get_photo_from_id(id)
					var data = await ApiRequest.get_photo_info_from_id(id)

					# COPY THE IMG LOCALLY, GET THAT PATH
					# USE THAT PATH
					# I DONT WANT TO CHANGE MY CODE!!!
					# 1. Save locally
					var img := Image.new()
					var error := img.load_jpg_from_buffer(bytes)
					if error != OK:
						push_error("load_jpg_from_buffer failed: %s" % error)
						return
					# 2. Path
					var path = "user://photos/{id}.jpg".format({"id": data["id"]})
					img.save_jpg(path, 0.9)
					# 3. Row like database
					var r = {}
					r["id"] = data["id"]
					r["path"] = path
					r["date"] = data["date"]
					r["description"] = data["description"]
					result.append(r)
			# iterate through results
			# result will be a list of dictionaries
			# each dictionary is a row
			for row in result:
				print(row)
				var path = row["path"]
				# load image object to get image information
				
				curr_id = row["id"]
				photos.append(connection.add_photo(row["path"],row["id"]))
			
			# finished loading all photos
			num_of_photos_on_launch = Database.num_of_photos
			first_launch = false
		# load more photos if the database was changed
		if db_changed:
			# when adding a new photo, the most recent img id would be num_of_photos_on_launch + 1
			# why 'Database.num_of_photos + 2'? so range can actually get the new id
			var result = []
			if not Global.connect_to_api:
				print("[PL]DB CHANGED: ", num_of_photos_on_launch + 1, " ", Database.num_of_photos + 2)
				for i in range(num_of_photos_on_launch + 1, Database.num_of_photos + 2):
					
					var str_query = "SELECT * FROM photos WHERE id = " + str(i)
					print("[PL]--> ", str_query)
					Database.db.query(str_query)
					result = Database.db.query_result
					print("[PL]--> ",result)
					
					curr_id = result[0]["id"]
			else:
				print("[PL] API Server DB Changed")
				
				
				pass
			photos.append(connection.add_photo(result[0]["path"],result[0]["id"]))
			db_changed = false
			
func queue_all():
	photo_queue = []
	for photo in photos:
		photo_queue.append(photo)
	
func photo_query(query_input, params, query_type := DatabaseConnection.TAGS) -> Array:
	photo_queue = connection.photo_query(photos, query_input, params, query_type)
	return photo_queue
		
