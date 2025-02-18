extends Control
class_name ItemContainer

# dimension of container
var width : int 
var height : int

var ratios : PackedInt32Array = []
var items : Array = []


func _init(iwidth : int, iheight : int) -> void:
	self.width = iwidth
	self.height = iheight
	
func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize) 
	
func add_item(input : Control) -> void:
	print("[IC, add_item()] ADDING: ", input)
	if ratios.size() <= items.size():
		print("[IC, add_item()] too many items")
		return
	add_child(input)
	input.visible = self.visible
	input.size.x = self.width
	input.size.y = self.height
	items.append(input)
	update_container(input)
	
func update_container(input : Control) -> void:
	pass

func resize() -> void:
	print("[IC, resize()] called")
	height = get_viewport().size.y
	width = get_viewport().size.x
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

func get_ratio(index : int) -> float:
	var ratio_total = 0
	var ratio_size = ratios.size()
	for r in ratios:
		ratio_total += r
	
	return float(ratios[index])/ratio_total

func add_text(text : String, text_fill_percent : float = 1) -> Label:
	
	var new_text = Label.new()
	
	#var new_font = FontVariation.new()
	
	#new_text.add_theme_font_override("font", new_font)
	new_text.add_theme_font_size_override("font_size", 64)
	new_text.add_theme_color_override("font_color", Color(0,0,0))
	
	print("[IC, add_text] adding new RichTextLabel with text: ", text)
	new_text.text = text
	
	add_item(new_text)
	return new_text
