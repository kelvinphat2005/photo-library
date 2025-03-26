extends Node
class_name ImagePreview
# WHAT THE IMAGE ACTUALLY SHOWS


var win_size 
var preview_photo : Photo # Photo that is being previewed
var photo_cache : Photo


var preview_container : HorizontalItemContainer
var details_container : VerticalItemContainer

# Right hand details box
@export var details_width : int = 500

var debug = true

# TODO: ENABLE/DISABLE CAMERA MOVEMENT WHEN IMAGE IS BEING PREVIEWED

func _ready() -> void:
	if debug:
		Database.create_database()
		Database.db.open_db()
		PhotoLoader.active = true
	
	self.visible = false
	
	win_size = get_viewport().size
	
	SignalBus.connect("_photo_tile_clicked", show)
	get_tree().get_root().size_changed.connect(resize)


func _process(delta) -> void:
	if Input.is_action_just_released("debug_0"):
		show(PhotoLoader.photos[0])
	if Input.is_action_just_released("debug_9"):
		close()
	
func close() -> void:
	self.visible = false
	Global.photo_tile_interact = true
	preview_photo = null
	remove_child(preview_container)
	preview_container.queue_free()
	
func show(photo : Photo) -> void:
	photo_cache = photo # cache so if resize, use this
	if get_child_count() > 0:
		print("[Image_Preview, show()] PREVIEW ALREADY LOADED")
		return
	
	print("[Image_Preview, show()] Called")


	# clone photo
	preview_photo = Photo.new(photo.original_x, photo.original_y, photo.id, photo.path)

	self.visible = true
	Global.photo_tile_interact = false
	win_size = get_viewport().size
	preview_container = HorizontalItemContainer.new(win_size.x, win_size.y, ItemContainer.Types.FIXED)
	
	var preview_photo2 = Photo.new(photo.original_x, photo.original_y, photo.id, photo.path)
	
	if win_size.x <= details_width * 2:
		# win_size.x <= details_width * 2
		# If window size is too small:
		# dont show preview image
		# AND fill window with details
		
		#init_details_container(details_width * 2)
		preview_container.add_item(preview_photo2, win_size.x)
		preview_container.resize()
	else:
		print("[Image_Preview, show()] XXXXX")
		var sizes = [win_size.x - details_width, details_width]

		print(sizes)
		preview_container.add_item(preview_photo, sizes[0])
		preview_container.add_item(preview_photo2, sizes[1])
		#init_details_container(sizes[1])
		#preview_container.add_item(details_container, sizes[1])
		preview_container.resize()
		#details_container.resize()
	
	preview_container.z_index_children(50)
	add_child(preview_container)
	
func init_details_container(width : int) -> void:
	win_size = get_viewport().size
	details_container = VerticalItemContainer.new(width, win_size.y, ItemContainer.Types.FIXED)
	
	
func resize() -> void:
	print("[Image_Preview, resize()] Called")
	if get_child_count() > 0:
		close()
		show(photo_cache)
