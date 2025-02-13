extends Node
class_name ImagePreview

var win_size 
var photo : Photo # Photo that is being previewed

var photo_preview_pos : Vector2

@onready var preview_photo : Photo
@export var camera : Camera2D

# TODO: ENABLE/DISABLE CAMERA MOVEMENT WHEN IMAGE IS BEING PREVIEWED

func _init():
	preview_photo = Photo.new(-1,-1,0,"")
	add_child(preview_photo)

func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize)
	win_size = get_viewport().size

func _process(delta) -> void:
	
	if Input.is_action_just_released("debug_0"):
		test()

	
func test():
	print("DEBUG 0")
	set_photo(PhotoLoader.photos[0])
	center_preview()
	
# places the preview in the center of the screen
# no matter windowsize or scroll position
func center_preview() -> void:
	print("[IMG PREV] center_preview()")
	# preview_photo.offset = win_size / 2
	preview_photo.position.y = camera.position.y + win_size.y / 2
	
	preview_photo.position.x = int(win_size.x) / 2

# Set the current preview photo to said photo
func set_photo(photo : Photo) -> void:
	print("[IMG PREV] set_photo()")
	# if resize is called multiple times at once
	# this prevents it from decreasing in size continuinly
	preview_photo.scale = Vector2(1,1)
	# just copy texture instead of repositioning photo so no need to store initial
	# image variables (scale, position)
	preview_photo.texture = photo.texture
	preview_photo.x = photo.original_x
	preview_photo.y = photo.original_y
	preview_photo.id = photo.id
	preview_photo.aspect_ratio = photo.aspect_ratio
	preview_photo.aspect_ratio_r = photo.aspect_ratio_r
	# scale photo to fill screen
	resize()
	
func resize() -> void:
	print("[IMG PREV] resize()")
	win_size = get_viewport().size
	if preview_photo.id > 0:
		print("d")
		var new_x = preview_photo.calc_new_x(win_size.y)
		preview_photo.resize(new_x, win_size.y)
		
