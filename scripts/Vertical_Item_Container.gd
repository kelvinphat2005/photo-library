extends ItemContainer
class_name VerticalItemContainer


func update_container(input : Control) -> void:
	print("[VIC, update_container()] called")
	var curr_index = items.size() - 1
	
	var new_height = height * get_ratio(curr_index)
	input.size.y = new_height
	print("[VIC, update_container()] curr_index: ", curr_index, " new_height: ", new_height)
	
	if curr_index > 0:
		var pos_offset = items[curr_index - 1].size.y + items[curr_index - 1].position.y
		input.position.y += pos_offset
		print("[VIC, update_container(), position] ", input.position.y)
	
	for itm in items:
		
		if itm is Label:
			print("[VIC, update_container()] Updating font_size of ", itm, " to ", new_height / 2)
			itm.add_theme_font_size_override("font_size", new_height / 2)
	
	return
