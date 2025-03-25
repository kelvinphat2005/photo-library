extends ItemContainer
class_name HorizontalItemContainer

func update_container() -> void:
	print("[HIC, update_container] CALLED")
	if type == Types.RATIO:
		print("[HIC, update_container] Type = RATIO: ")
		var index = 0
		var offset = 0
		for item in items:
			item.position.x = 0
			var new_width = width * get_ratio(index)
			print("[HIC, update_container] new_width: ", new_width)
			index += 1
			item.position.x += offset
			if item is Control:
				item.size.x = new_width
				
			elif item is Photo:
				var new_y = item.calc_new_y(new_width)
				item.resize(new_width, new_y)
				
			offset += new_width
			
			print("[HIC, update_container] new offset: ", offset)
	elif type == Types.FIXED:
		print("[HIC, update_container] Type = FIXED: ")
		var index = 0
		var offset = 0
		for item in items:
			item.position.x = 0
			var new_width = sizes[item]
			item.position.x += offset
			if item is Control:
				pass
			elif item is Photo:
				
				var new_y = item.calc_new_y(new_width)
				# if photo is too tall:
				if new_y > height:
					print("[HIC, update_container] Photo TOO TALL!! ")
					var resized_width = item.calc_new_x(height)
					item.resize(resized_width, height)
					# center image
					var remaining_width = new_width - resized_width
					item.position.x += remaining_width / 2
				else:
					item.resize(new_width, new_y)
			
			offset += new_width
			print("[HIC, update_container] new offset: ", offset)
