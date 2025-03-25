extends Node2D

var menu_box : VerticalItemContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var window = get_viewport().size
	# create new VBox
	menu_box = VerticalItemContainer.new(200, window.y)
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
