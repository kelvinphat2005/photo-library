extends Node
class_name DatabaseConnection 

enum {ID, TAGS, ALBUMS, NONE, AND, OR}

func add_photo(path : String, id : int, photo_name := "", description := "", date := "") -> PhotoTile:
	return
	
func photo_query(query_input, params, query_type := TAGS) -> Array:
	return []
	
func remove_photo(id : int) -> void:
	return
	
