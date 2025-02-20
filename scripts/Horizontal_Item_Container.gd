extends ItemContainer
class_name HorizontalItemContainer

func update_container(input : Control) -> void:
	print("[VIC, update_container()] called")
	var curr_index = items.size() - 1
	
	if type == Types.RATIO:
		var new_width = width * get_ratio(curr_index)
		input.size.x = new_width
		print("[VIC, update_container()] curr_index: ", curr_index, " new_width: ", new_width)
	elif type == Types.FIXED:
		var new_width = sizes[input]
		assert(new_width > 0, "INVALID HEIGHT")
		input.size.x = new_width
	
	# position Control Nodes in the right position
	if curr_index > 0:
		var pos_offset = items[curr_index - 1].size.x + items[curr_index - 1].position.x
		input.position.x += pos_offset
		print("[VIC, update_container(), position] ", input.position.x)
	
	return
