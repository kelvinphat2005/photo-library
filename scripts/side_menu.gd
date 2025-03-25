extends Node2D

var menu_box : VerticalItemContainer
@onready var background = preload("res://textures/white.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window = get_viewport().size
	# create new VBox
	menu_box = VerticalItemContainer.new(250, window.y, ItemContainer.Types.FIXED, 20)
	menu_box.init_background(background)
	
	var header = Label.new()
	header.text = " John Photos"
	header.add_theme_color_override("font_color", Color(0,0,0,1))
	header.add_theme_font_size_override("font_size", 30)
	menu_box.add_item(header, 200)
	
	add_child(menu_box)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
