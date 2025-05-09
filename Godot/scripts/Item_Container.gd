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

var padding : int = 0

var background : MeshInstance2D

func _init(iwidth : int, iheight : int, type := Types.FIXED, padding : int = 0) -> void:
	self.width = iwidth
	self.height = iheight
	self.type = type
	self.padding = padding
	
	# control node doesnt have offset
	# just make up for this by moving the node
	# stuff like label nodes have their pivot on the top left by default
	# position.x += self.width/2
	# position.y += self.height/2
	
func z_index_children(new : int) -> void:
	for i in items:
		i.z_index = new
		if i is ItemContainer:	
			i.z_index_children(new)
	
func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize) 
	
# Types.RATIO = Height does matter, input-length does not matter
# Types.FIXED = Height does not matter, input-length does matter
func add_item(input, length : int = -1) -> void:
	if input is Control or input is Photo:
		pass
	else:
		print("[IC, add_item] INVALID TYPE XXXXXXXXXXXXXXXXXXXXXX")
		return
	
	print("[IC, add_item()] ADDING: ", input)
	if ratios.size() <= items.size():
		if type == Types.RATIO:
			print("[IC, add_item()] too many items")
			return
	add_child(input)
	input.visible = self.visible
	if input is Control:
		input.size.x = self.width
		input.size.y = self.height
	elif input is Photo or input is PhotoTile:
		var new_y = input.calc_new_y(length)
		var new_x
		# if image is too tall
		# the bottom will be cut off, fix:
		if new_y > height:
			new_x = input.calc_new_x(height)
			new_y = height
			input.resize(new_x, new_y)
		else:
			input.resize(length, new_y)
		# image offset
		
	else:
		print("ERROR")
	items.append(input)
	
	if type == Types.FIXED:
		assert(length > 0, "INVALID HEIGHT")
		sizes[input] = length
	
	
func update_container() -> void:
	pass

func resize() -> void:
	print("[IC, resize()] called")
	if type == Types.RATIO:
		print("[IC, resize()] RATIO")
		resize_ratio()
	elif type == Types.FIXED:
		print("[IC, resize()] FIXED")
		resize_fixed()
		
func resize_ratio() -> void:
	update_container()

func resize_fixed() -> void:
	update_container()

func init_background(texture) -> void:
	print("[IC, init_background()] called with ", texture)
	background = MeshInstance2D.new()
	
	# Create new mesh
	var mesh = QuadMesh.new()
	mesh.size.x = width * 2
	mesh.size.y = height * 2
	
	background.mesh = mesh
	# Give mesh a texture
	background.texture = texture
	
	add_child(background)
	
	

func get_ratio(index : int) -> float:
	var ratio_total = 0
	var ratio_size = ratios.size()
	for r in ratios:
		ratio_total += r + padding
	ratio_total -= padding
	
	return float(ratios[index])/ratio_total
