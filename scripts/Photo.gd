extends Sprite2D
class_name Photo

# resolution
var original_x : int
var original_y : int
var x
var y
# used to resize/scale
var aspect_ratio : float
var aspect_ratio_r : float
# database
var id : int
var path : String


func  _init(ix, iy, iid, ipath):
	original_x = ix
	x = ix
	original_y = iy
	y = iy
	id = iid
	path = ipath
	# used to calculate new resolutions
	aspect_ratio = float(original_x) / original_y
	aspect_ratio_r = float(original_y) / original_x
	# position of image is located in the center
	# changing offset AFTER resizing and using new values x and y vals gives the wrong offset
	# places location of image on top left of the photo
	offset.x = float(x)/2
	offset.y = float(y)/2
	load_img()
	
# given a y resolution, output a new x resolution
# while maintaining aspect ratio
func calc_new_x(y_val : int) -> int:
	return int(y_val*aspect_ratio)
	
# given a x resolution, output a new y resolution
# while maintaining aspect ratio
func calc_new_y(x_val : int) -> int:
	return int(x_val*aspect_ratio_r)

func resize(new_x, new_y) -> void:
	# var x_scale = float(new_x)/original_x
	# var y_scale = float(new_y)/original_y
	var x_scale = float(new_x)/x
	var y_scale = float(new_y)/y
	
	print("x_scale: ", x_scale, " | y_scale: ", y_scale)
	scale.x *= x_scale
	scale.y *= y_scale
	x *= float(x_scale)
	y *= float(y_scale)
	
	
	print("x: ", x, " | y: ", y)

# uses path to load img
func load_img() -> bool:
	if Database.db and path != "":
		var img = Image.load_from_file(path)
		texture = ImageTexture.create_from_image(img)
		return true
	return false
