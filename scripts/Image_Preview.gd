extends Node
class_name ImagePreview

var win_size 
var photo : Photo # Photo that is being previewed

var photo_preview_pos : Vector2

@onready var preview_photo : Photo = Photo.new(-1,-1,0,"")
@export var camera : Camera2D
@export var background : MeshInstance2D

# TODO: ENABLE/DISABLE CAMERA MOVEMENT WHEN IMAGE IS BEING PREVIEWED

func _ready() -> void:
	self.visible = false
	add_child(preview_photo)
	
	win_size = get_viewport().size
	
	SignalBus.connect("_photo_tile_clicked", show)
	get_tree().get_root().size_changed.connect(resize)

func _process(delta) -> void:
	if Input.is_action_just_released("debug_0"):
		self.visible = false
	
func show(photo):
	print("[IMG PREV] ----------- show() ---------")
	win_size = get_viewport().size
	
	set_photo(photo)
	self.visible = true
	background.scale = win_size
	
	
# places the preview in the center of the screen
# no matter windowsize or scroll position
func center_preview() -> void:
	win_size = get_viewport().size
	print("[IMG PREV] center_preview()")
	self.position.y = camera.position.y + win_size.y / 2	
	self.position.x = int(win_size.x) / 2
	preview_photo.position.x = camera.position.x

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
	resize(000, 000)

# resize photo to fit the screen
# photo by default is centered
# lpadding adds padding to left, rpadding adds padding to the right
# ---> this is useful for photos that are wide
func resize(lpadding = 0, rpadding = 0) -> void:
	center_preview()
	print("[IMG PREV] resize()")
	print("[IMG PREV] Window size: ", win_size.x, "x", win_size.y)
	win_size = get_viewport().size
	
	var total_x_padding = lpadding + rpadding
	
	if preview_photo.id > 0:
		
		var new_x = preview_photo.calc_new_x(win_size.y) 

		# check if the image is too large
		if new_x > win_size.x - total_x_padding:
			# TOO LONG
			var new_y = preview_photo.calc_new_y(win_size.x - total_x_padding) # photo fit in 
			preview_photo.resize(win_size.x - total_x_padding, new_y)
		else:
			preview_photo.resize(new_x, win_size.y)
			
		# since image is centered, there is already some "padding"
		# calculate that number
		var curr_lpadding = total_x_padding / 2
		var curr_rpadding = total_x_padding / 2
		# determine how much more padding to add to hit target
		var difference = lpadding - curr_lpadding
		preview_photo.position.x += difference

		
		
