extends Node

var photos : Array = []
var photo_queue : Array =[]

# tracking whether to load more images
var active : bool = false
var first_launch : bool = true
var db_changed : bool = false

var num_of_photos_on_launch : int

var curr_id : int = -1

enum {ID, TAGS, NONE, AND, OR}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active:
		# only load ALL photos at beginning
		if first_launch:
			var str_query = "SELECT * FROM photos"
			print("PHOTO LOADER str_query: ", str_query)
			Database.db.query(str_query)
			var result = Database.db.query_result
			print(result)
			
			# iterate through results
			# result will be a list of dictionaries
			# each dictionary is a row
			for row in result:
				print(row)
				var path = row["path"]
				# load image object to get image information
				
				add_photo(row)
			
			# finished loading all photos
			num_of_photos_on_launch = Database.num_of_photos
			first_launch = false
		# load more photos if the database was changed
		if db_changed:
			# when adding a new photo, the most recent img id would be num_of_photos_on_launch + 1
			# why 'Database.num_of_photos + 2'? so range can actually get the new id
			print("[PL]DB CHANGED: ", num_of_photos_on_launch + 1, " ", Database.num_of_photos + 2)
			for i in range(num_of_photos_on_launch + 1, Database.num_of_photos + 2):
				
				var str_query = "SELECT * FROM photos WHERE id = " + str(i)
				print("[PL]--> ", str_query)
				Database.db.query(str_query)
				var result = Database.db.query_result
				print("[PL]--> ",result)
				
				add_photo(result[0])
				num_of_photos_on_launch += 1
				
			db_changed = false
			
func queue_all():
	photo_queue = []
	for photo in photos:
		photo_queue.append(photo)
			
# ADD PHOTO THE PHOTO_LOADER AND CURRENT LOADED PHOTOS
# INPUT: ROW OF DATABASE
func add_photo(result):
	# IF ADDING DUPLICATE PHOTO AND DB_CHANGED IS MARKED TRUE:
	# BUG: THIS WILL BE RUN AND PROGRAM WIL FAIL!!
	var path = result["path"]
	# load image object to get image information
	var image = Image.load_from_file(path)
	var new_photo_tile = PhotoTile.new(image.get_size().x, image.get_size().y, result["id"], path)
	new_photo_tile.description = "" # placeholder
	new_photo_tile.photo_name = result["name"]
	#new_photo_tile.tags = result["tags"]
	new_photo_tile.date = result["date"]
	
	photos.append(new_photo_tile)
	curr_id = result["id"]
	Database.num_of_photos += 1
	
func photo_query(query_input, params, query_type := TAGS) -> Array:
	if query_type == ID:
		photo_queue = query_id(query_input, params, query_type)
		return photo_queue
	elif query_type == TAGS:
		photo_queue = query_tag(query_input, params, query_type)
		return photo_queue
	return []
		
func query_id(id, params, query_type) -> Array:
	var db = Database.db
	var output = []
	
	
	return output
	
func query_tag(tag, params, query_type) -> Array:
	var db = Database.db
	var output = []
	var type : String
	
	print("[PL, query_tag()] tag(s): ", tag)
	
	if tag is String:
		tag = [tag]
		print("[PL, query_tag()] string to list: ", tag)
		
	
		
	if tag is Array:
		print("[PL, query_tag] YYYYY")
		if params == PhotoLoader.OR:
			print("[PL, query_tag] OR search")
			var dict = {}
			
			for t in tag:
				var query = "SELECT photo_id FROM tags WHERE tag == '{tag}'".format({
					"tag": t
				})
				print("[PL, query_tag()] querying database: ", query)
				db.query(query)
				var result = db.query_result
				print("[PL, query_tag()] result: ", result)
		
				# PREVENT DUPLICATES
				for photo_in_db in result:
					var index = photo_in_db["photo_id"] - 1
					dict[index] = true
			# ADD PHOTOS TO OUTPUT
			for val in dict:
				print("[PL, dict{}] ", val)
				output.append(photos[val])
					
		elif params == PhotoLoader.AND:
			print("[PL, query_tag] AND search")
			var dict = {}
			var val_to_match = tag.size()
			
			for t in tag:
				var query = "SELECT photo_id FROM tags WHERE tag == '{tag}'".format({
					"tag": t
				})
				print("[PL, query_tag()] querying database: ", query)
				db.query(query)
				var result = db.query_result
				print("[PL, query_tag()] result: ", result)
				for photo_in_db in result:
					var index = photo_in_db["photo_id"] - 1
					if dict.has(index):
						dict[index] += 1
					else:
						dict[index] = 1
			for val in dict:
				if dict[val] == val_to_match:
					print("[PL, dict{}] ", val)
					output.append(photos[val])
		

			
	else:
		print("[PL, query_tag()] SOMETHING WENT WRONG")
		return []
	
	return output
