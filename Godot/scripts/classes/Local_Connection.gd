extends DatabaseConnection
class_name LocalConnection

func add_photo(path : String, id : int, photo_name := "", description := "", date := "") -> PhotoTile:
	# load image object to get image information
	var image = Image.load_from_file(path)
	var new_photo_tile = PhotoTile.new(image.get_size().x, image.get_size().y, id, path)
	new_photo_tile.description = "" # placeholder
	new_photo_tile.photo_name = photo_name
	new_photo_tile.date = date
	
	Database.num_of_photos += 1
	return new_photo_tile	
	
func photo_query(photos, query_input, params, query_type := TAGS) -> Array:
	if query_type == ID:
		var photo_queue = query_id(photos, query_input, params)
		return photo_queue
	elif query_type == TAGS or query_type == ALBUMS:
		var photo_queue = query(photos, query_input, params, query_type)
		return photo_queue
	return []
	
func remove_photo(id : int) -> void:
	return
	
func query_id(photos, id, params) -> Array:
	var db = Database.db
	var output = []
	
	return output
	
func query(photos, search_list, params, query_type) -> Array:
	var db = Database.db
	var output = []
	
	var table : String
	var descriptor : String
	
	print("[PL, query_tag()] search(es): ", search_list)
	
	if search_list is String:
		search_list = [search_list]
		print("[PL, query_tag()] string to list: ", search_list)
		
	if query_type == TAGS:
		table = "tags"
		descriptor = "tag"
	elif query_type == ALBUMS:
		table = "photo_album"
		descriptor = "album_id"
	else:
		print("[PL, query_tag] QUERY_TYPE: SOMETHING WENT WRONG")
		return [-1]
		
	if params == OR:
		print("[PL, query_tag] OR search")
		var dict = {}
		
		for search in search_list:
			var query = "SELECT photo_id FROM {table} WHERE {descriptor} == '{search}'".format({
				"table": table, "descriptor": descriptor, "search": search
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
				
	elif params == AND:
		print("[PL, query_tag] AND search")
		var dict = {}
		var val_to_match = search_list.size()
		
		for search in search_list:
			var query = "SELECT photo_id FROM {table} WHERE {descriptor} == '{search}'".format({
				"table": table, "descriptor": descriptor, "search": search
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
		
	return output
