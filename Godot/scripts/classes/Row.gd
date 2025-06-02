extends Node2D
class_name Row

var photos : Array = []
var width : int # in px
var available_width : float
var img_padding : int = 4
@export var starting_height : int = 400
var curr_height
var full : bool = false # used by home to determine whether to add more photos


func _init(iwidth):
	width = iwidth
	available_width = iwidth
	
# add photo if there is room
# if the width of the photo is too large, scale all photos (incl. photo being added)
# so that all the photos are able to fit within the row without spilling
# if row is already filled to the max, do not add and return false else return true
func add_photo(photo : PhotoTile) -> bool:
	
	photo.resize(photo.calc_new_x(starting_height),starting_height)
	
	if (available_width < 5):
		# undo resize
		photo.x = photo.original_x
		photo.scale.x = 1
		photo.y = photo.original_y
		photo.scale.y = 1
		print("ROW DOESN'T HAVE ROOM")
		return false
	
	
	available_width -= photo.x
	if len(photos) > 1:
		available_width -= img_padding
	
	if (available_width < 5): 
		print("MAKING ROOM FOR NEW IMAGE")
		# print("New photo current width: ", photo.x)
		photos.append(photo)
		# FILL WHOLE ROW W/ IMAGES
		fill()
		curr_height = photos[0].y
		
		return true

	else:
		print("ADDED IMAGE")
		# print("Available width: ", available_width)
		photos.append(photo)
		curr_height = photos[0].y
		return true

# if row has empty space, scale images so that they up all available room
func fill() -> void:
	var used_width = width - available_width
	var new_scale = float(width)/(used_width + img_padding)
	


	# TODO IF SCALE IS TOO LOW, REDO CHANGES

	# now resize all photos using new scale
	for p in photos:
		p.resize(p.x * new_scale, p.y * new_scale)
		
	# recalc available width
	available_width = width
	for p in photos:
		available_width -= p.x + img_padding
	available_width += img_padding
		
	# print("Available width: ", available_width)
	curr_height = photos[0].y
	
	full = true

	pass

# remove last photo at the highest index
func del_photo() -> void:
	var last_index = photos.size() - 1
	if last_index < 0:
		return
	# GET LAST PHOTO
	var last_photo : Photo = photos[last_index]
	available_width += last_photo.x + img_padding
	# REMOVE LAST PHOTO FROM SCENE
	photos.pop_at(last_index)
	remove_child(last_photo)
	# RESET CHANGES DONE TO THE PHOTO
	last_photo.scale.x = 1
	last_photo.scale.y = 1
	last_photo.x = last_photo.original_x
	last_photo.y = last_photo.original_y
	


func load_images() -> void:
	var offset = 0
	for p in photos:
		# print("offset: ", offset, " | p.x: ", p.x)
		p.position.x = offset
		offset += p.x + img_padding
		if p.get_parent() != self:
			add_child(p)
