extends ItemContainer
class_name VerticalItemContainer


func update_container(input : Control) -> void:
	print("[VIC, update_container()] called")
	var curr_index = items.size() - 1
	
	var new_height = height * get_ratio(curr_index)
	input.size.y = new_height
	print("[VIC, update_container()] ", curr_index, " ", new_height)
	
	if curr_index > 0:
		var pos_offset = items[curr_index - 1].size.y
		input.position.y += pos_offset
		print("[VIC, update_container(), position] ", input.position.y)
	
	return
