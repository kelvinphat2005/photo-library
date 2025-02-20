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
	position.x += self.width/2
	position.y += self.height/2
	
	
	
func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize) 
	
# Types.RATIO = Height does matter, input-length does not matter
# Types.FIXED = Height does not matter, input-length does matter
func add_item(input : Control, length : int = -1) -> void:
	print("[IC, add_item()] ADDING: ", input)
	if ratios.size() <= items.size():
		if type == Types.RATIO:
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
		print("[IC, resize()] RATIO")
		resize_ratio()
	elif type == Types.FIXED:
		print("[IC, resize()] FIXED")
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

func init_background(texture) -> void:
	print("[IC, init_background()] called with ", texture)
	background = MeshInstance2D.new()
	
	# Create new mesh
	var mesh = QuadMesh.new()
	mesh.size.x = width
	mesh.size.y = height
	
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
