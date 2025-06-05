extends Node

@export var test_mode : bool = false

@onready var http_request : HTTPRequest = HTTPRequest.new() # preload 1 http request
@onready var img := Image.new()

var queue_id = []

# with an id, return the image data
# id, name, date, description
func get_photo_info_from_id(id : int):
	var url = Global.SERVER_IP + "/photos/" + str(id)
	print("[HTTP REQUEST, get_photo_info_from_id] url: ", url)
	
	http_request.request(url)
	var response = await http_request.request_completed
	var new_http_request : HTTPRequest
	
	if response[1] != 0:
		print("[HTTP REQUEST] No response")
		# if no response, create new HTTP Node
		new_http_request = HTTPRequest.new()
		add_child(new_http_request)
		new_http_request.request(url)
		response = await new_http_request.request_completed

	var result = response[0]
	var response_code = response[1]
	# var _headers = response[2]
	var body = response[3]
	
	var json = JSON.parse_string(body.get_string_from_utf8())  
	img.load_jpg_from_buffer(body)
	
	if new_http_request:
		new_http_request.queue_free()
	
	return ImageTexture.create_from_image(img)

# With an ID, return the image image texture
# this call only gets the raw data of the image
func get_photo_from_id(id : int) -> ImageTexture:
	var url = Global.SERVER_IP + "/photos/" + str(id) + "/raw"
	print("[HTTP REQUEST, get_photo_from_id] url: ", url)
	# check if primary http_request is being used
	# if it is, create another HTTP Request Node
	
	http_request.request(url)
	var response = await http_request.request_completed
	var new_http_request : HTTPRequest
	
	if response[1] != 0:
		print("[HTTP REQUEST, get_photo_from_id] No response")
		# if no response, create new HTTP Node
		new_http_request = HTTPRequest.new()
		add_child(new_http_request)
		new_http_request.request(url)
		response = await new_http_request.request_completed

	

	var result = response[0]
	var response_code = response[1]
	# var _headers = response[2]
	var body = response[3]
	
	# var json = JSON.parse_string(body.get_string_from_utf8())  
	
	
	if new_http_request:
		new_http_request.queue_free()
	
	img.load_jpg_from_buffer(body)
	return ImageTexture.create_from_image(img)
	
func get_photo_size() -> int:
	var url = Global.SERVER_IP + "/size/photos"
	print("[HTTP REQUEST, photo_size] url: ", url)
	
	var size = -1
	# if no response, create new HTTP Node
	var new_http_request := HTTPRequest.new()
	add_child(new_http_request)
	new_http_request.request(url)
	var response = await new_http_request.request_completed
	
	
	
	var result = response[0]
	var response_code = response[1]
	# var _headers = response[2]
	var body = response[3]
	
	var json = JSON.parse_string(body.get_string_from_utf8())  
	size = json["size"]
	print("[HTTP REQUEST, photo_size] size: ", size)
	
	new_http_request.queue_free()
	return size

func http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, request, delete : bool) -> void:
	print("[HTTP REQUEST] HTTP Request Completed: {result} response code: {response_code} headers: {headers}\nbody: {body}".format(
		{
			"result": result,
			"response_code": response_code,
			"headers": headers,
			"body": "body",
		}
	))
	
	if test_mode:
		print("[HTTP REQUEST] CREATING TEST IMAGE")
		img.load_jpg_from_buffer(body)
		var sprite := Sprite2D.new()
		sprite.texture = ImageTexture.create_from_image(img)
		get_parent().add_child(sprite)
	
	
	img.load_jpg_from_buffer(body)
	ImageTexture.create_from_image(img)
	
	if delete:
		request.queue_free()
	
	
func _ready():
	# connect the first (primary) HTTP
	http_request.request_completed.connect(self.http_request_completed)
	add_child(http_request)
	
	if test_mode:
		print("[HTTP REQUEST] Test")
		Global.connect_to_api = true

	
	if not Global.connect_to_api:
		print("[HTTP REQUEST] connect_to_api is false, removing self from scene")
		get_parent().remove_child(self)
		queue_free()
		return

	print("[HTTP REQUEST] Start")
	
