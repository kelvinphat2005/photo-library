extends TileFactory
class_name LocalTileFactory

func add_photo(path : String, id : int, photo_name := "", description := "", date := "") -> PhotoTile:
	# load image object to get image information
	var image = Image.load_from_file(path)
	var new_photo_tile = PhotoTile.new(image.get_size().x, image.get_size().y, id, path)
	new_photo_tile.description = description
	new_photo_tile.photo_name = photo_name
	new_photo_tile.date = date
	
	Database.num_of_photos += 1
	return new_photo_tile
	
