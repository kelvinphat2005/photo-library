extends Node

var photos : Array = []

# tracking whether to load more images
var active : bool = false
var first_launch : bool = true
var db_changed : bool = false

var num_of_photos_on_launch : int

var curr_id : int = -1

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
				var image = Image.load_from_file(path)
				var new_photo = PhotoTile.new(image.get_size().x, image.get_size().y, row["id"], path)
				photos.append(new_photo)
				curr_id = row["id"]
				Database.num_of_photos += 1
			
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
				
				add_photo(result)
				num_of_photos_on_launch += 1
				
			db_changed = false
			
			
func add_photo(result):
	# IF ADDING DUPLICATE PHOTO AND DB_CHANGED IS MARKED TRUE:
	# THIS WILL BE RUN AND PROGRAM WIL FAIL!!
	var path = result[0]["path"]
	# load image object to get image information
	var image = Image.load_from_file(path)
	var new_photo = PhotoTile.new(image.get_size().x, image.get_size().y, result[0]["id"], path)
	photos.append(new_photo)
	curr_id = result[0]["id"]
	
	Database.num_of_photos += 1
