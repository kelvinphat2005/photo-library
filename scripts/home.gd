extends Node

@export var camera : Camera2D
@export var file_dialog : FileDialog
@export var px_per_scroll : int = 35
var y_pos : float = 0
var win_size : Vector2i

# row attributes
var rows : Array # stores array of all rows
var curr_row : int = 0 # the index of the row to be loaded next
var row_height_offset : int = 0
@export var row_padding_y : int = 8

# the index of the photo to be loaded next
var curr_photo_index : int = -1
var curr_photo_id_offset : int = 0

var prev_window_length : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Database.create_database()
	Database.db.open_db()
	PhotoLoader.active = true
	
	SignalBus.connect("_update_row_height_offset", _add_row_height_offset)

func _process(delta):
	win_size = get_viewport().size
	if Input.is_action_just_released("debug_1"):
		test()
	if Input.is_action_just_released("debug_2"):
		test2()
	if Input.is_action_just_released("debug_3"):
		test3()
	if Input.is_action_just_released("debug_4"):
		test4()
	if Input.is_action_just_released("debug_5"):
		test5()
	
	# align camera with the images
	# by default the photos start at the very top left
	camera.offset.x = win_size.x / 2
	camera.offset.y = win_size.y / 2
	
	
	#print(camera.position.y)
	if Input.is_action_just_released("scroll_up"):
		camera.position.y -= px_per_scroll
		# prevents camera from going too far up
		camera.position.y = clamp(camera.position.y, 0, 1000000)
	if Input.is_action_just_released("scroll_down"):
		camera.position.y += px_per_scroll
	y_pos = camera.position.y

func load_new_row() -> void:
	print("[H, ROW]---------NEW CALL-------------")
	
	# dont make row if no photos
	print("[H, ROW]--> curr_photo_index - curr_photo_id_offset = ", curr_photo_index - curr_photo_id_offset)
	print("[H, ROW]--> ", curr_photo_index, " ", curr_photo_id_offset)
	
		
	# create new row
	var r : Row
	# get last row
	if rows.size() > 0:
		r = rows[rows.size() - 1]
	if rows.size() == 0 or r.full:
		print("[H, ROW]--> Creating new ROW")
		# if no rows, create new row
		# if prev row is full, create new row
		r = Row.new(1920)
		rows.append(r)
		add_child(r)
		r.position.y += row_height_offset
		# make it so the rows don't over lap
		curr_photo_index += 1
		
	else:
		print("[H, ROW]--> Using existing ROW")
		curr_photo_index = r.photos[r.photos.size() - 1].id
		print("[H, ROW]--> NEW CURR_PHOTO_INDEX = ", curr_photo_index)


	# start from last photo that couldn't be added to row
	# end at the last photo in total
	# curr_photo_id is the ID not index of photo
	# subtract 1 from curr_photo_id because the corresponding index is always -1 of the id
	print("[H, ROW]--X> ", curr_photo_index, " ", PhotoLoader.photos.size() - 1)
	for i in range(curr_photo_index, PhotoLoader.photos.size()):
		print("[H, ROW]--> ", curr_photo_index, " ", PhotoLoader.photos.size() - 1, " ", i)
		curr_photo_index = i
		var p = PhotoLoader.photos[i]
		
		# stop if row is full
		if not r.add_photo(p):
			print("[H, ROW]--> ROW IS FULL")
			curr_photo_index -= 1
			break
		
	if r.photos.size() > 0:
		row_height_offset = r.position.y + r.curr_height + row_padding_y
		r.load_images()
		
	print("[H, ROW] curr_photo_index = ", curr_photo_index)
	
func _add_row_height_offset(add : int) -> void:
	row_height_offset += add
	
func test():
	load_new_row()

func test2():
	file_dialog.popup()

func test3():
	var r = rows[0]
	r.del_photo()
	
func test4():
	var r = rows[0]
	r.fill()
	r.load_images()

# RESET ALL ROWS
# START FROM BEGINNING
func test5():
	print("DEBUG 5")
	
	for r in rows:
		for p in r.photos:
			r.remove_child(p)
		remove_child(r)
		r.queue_free()
	rows.clear()
	row_height_offset = 0
	curr_photo_index = -1

func _on_file_dialog_files_selected(paths: PackedStringArray) -> void:
	for i in paths:
		Database.add_photo(i)

func _on_file_dialog_file_selected(path: String) -> void:
	Database.add_photo(path)
