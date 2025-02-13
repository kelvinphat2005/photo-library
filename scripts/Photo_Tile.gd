extends Photo
class_name PhotoTile

func _input(event):
	# DETECT IF PHOTO IS CLICKED
	if event.is_action_pressed("click"):
		if is_pixel_opaque(get_local_mouse_position()):
			pass
			
func _process(delta):
	# DETECT IF MOUSE IS HOVERING OVER PHOTO
	if is_pixel_opaque(get_local_mouse_position()):
		modulate = Color(.5, .5, .5) # darken photo
	else:
		modulate = Color(1, 1, 1) # reset photo coloring
