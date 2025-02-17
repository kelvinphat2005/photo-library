extends Photo
class_name PhotoTile

func _input(event):
	# DETECT IF PHOTO IS CLICKED
	if event.is_action_pressed("click") and Global.photo_tile_interact:
		if is_pixel_opaque(get_local_mouse_position()):
			SignalBus._photo_tile_clicked.emit(self)
			
func _process(delta):
	# DETECT IF MOUSE IS HOVERING OVER PHOTO
	var tween = get_tree().create_tween()
	if is_pixel_opaque(get_local_mouse_position()):
		tween.tween_property(self, "modulate", Color(.5, .5, .5), .2)
	else:
		tween.tween_property(self, "modulate", Color(1, 1, 1), .1)
	tween.tween_callback(tween.kill)
