extends Control
class_name ItemContainer

# dimension of container
var width : int 
var height : int
# keep track of items in container
var items : Array = []
# different types of containers
enum Types {RATIO, FIXED}
var type : Types
# variables to keep track of sizes important to each type
var ratios : PackedInt32Array = []
var sizes : Dictionary = {} # default

func _init(iwidth : int, iheight : int, type := Types.FIXED) -> void:
	self.width = iwidth
	self.height = iheight
	self.type = type
	
func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize) 
	
# Types.RATIO = Height does matter, input-length does not matter
# Types.FIXED = Height does not matter, input-length does matter
func add_item(input : Control, length : int = -1) -> void:
	print("[IC, add_item()] ADDING: ", input)
	if ratios.size() <= items.size():
		print("[IC, add_item()] too many items")
		return
	add_child(input)
	input.visible = self.visible
	input.size.x = self.width
	input.size.y = self.height
	items.append(input)
	
	if type == Types.FIXED:
		assert(length > 0, "INVALID HEIGHT")
		sizes[input] = length
	
	update_container(input)
	
func update_container(input : Control) -> void:
	pass

func resize() -> void:
	print("[IC, resize()] called")
	if type == Types.RATIO:
		resize_ratio()
	elif type == Types.FIXED:
		resize_fixed()
		
func resize_ratio() -> void:
	#height = get_viewport().size.y
	#width = get_viewport().size.x
	# very dumb way
	var temp = []
	for item in items:
		item.position = Vector2(0, 0)
		temp.append(item)
	items.clear()
	for item in temp:
		items.append(item)
		item.size.x = self.width
		item.size.y = self.height
		update_container(item)

func resize_fixed() -> void:
	pass

func get_ratio(index : int) -> float:
	var ratio_total = 0
	var ratio_size = ratios.size()
	for r in ratios:
		ratio_total += r
	
	return float(ratios[index])/ratio_total
