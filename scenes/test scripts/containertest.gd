extends Node2D

var container_width := 600
var container_height := 1500

var all_containers = []

@onready var background = preload("res://textures/grey.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var main_container_vertical = VerticalItemContainer.new(
		container_width,
		container_height,
		ItemContainer.Types.FIXED
	)
	all_containers.append(main_container_vertical)
	var header_container_horizontal = HorizontalItemContainer.new(
		container_width,
		75,
		ItemContainer.Types.FIXED
	)
	
	main_container_vertical.add_item(header_container_horizontal, 75)
	
	# HEADER
	var exit_button = Button.new()
	var header = Label.new()
	header.text = " Info"
	header.add_theme_color_override("font_color", Color(0,0,0,1))
	header.add_theme_font_size_override("font_size", 50)
	
	header_container_horizontal.add_item(exit_button, 75)
	header_container_horizontal.add_item(header, 425)
	
	# DESCRIPTION
	var description = TextEdit.new()
	description.text = "Description"
	description.add_theme_color_override("font_color", Color(0,0,0,1))
	description.add_theme_font_size_override("font_size", 50)
	
	main_container_vertical.add_item(description, 75)
	
	# DETAILS
	var details_header = Label.new()
	details_header.text = "Details"
	details_header.add_theme_color_override("font_color", Color(0,0,0,1))
	details_header.add_theme_font_size_override("font_size", 20)
	var details_info = Label.new()
	details_info.text = "INFO INFO INFO INFO"
	details_info.add_theme_color_override("font_color", Color(0,0,0,1))
	details_info.add_theme_font_size_override("font_size", 50)
	
	main_container_vertical.add_item(details_header, 30)
	main_container_vertical.add_item(details_info, 75)
	
	
	
	
	
	
	all_containers.append(header_container_horizontal)
	
	main_container_vertical.init_background(background)
	
	main_container_vertical.z_index = 9
	main_container_vertical.z_index_children(10)
	add_child(main_container_vertical)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
