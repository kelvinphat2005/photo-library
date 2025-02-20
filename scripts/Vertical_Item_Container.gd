extends ItemContainer
class_name VerticalItemContainer


func update_container(input : Control) -> void:
	print("[VIC, update_container()] called")
	var curr_index = items.size() - 1
	
	if type == Types.RATIO:
		var new_height = height * get_ratio(curr_index)
		input.size.y = new_height
		print("[VIC, update_container()] curr_index: ", curr_index, " new_height: ", new_height)
	elif type == Types.FIXED:
		var new_height = sizes[input]
		assert(new_height > 0, "[VIC, update_container()] (new_height > 0) INVALID HEIGHT")
		input.size.y = new_height
	
	# position Control Nodes in the right position
	if curr_index > 0:
		var pos_offset = items[curr_index - 1].size.y + items[curr_index - 1].position.y
		input.position.y += pos_offset
		print("[VIC, update_container(), position] ", input.position.y)
	
	return
