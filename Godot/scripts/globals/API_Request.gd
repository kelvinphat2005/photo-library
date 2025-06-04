extends Node

@export var test_mode : bool = false

@onready var http_request : HTTPRequest = HTTPRequest.new() # preload 1 http request
@onready var img := Image.new()

var queue_id = []

func get_photo_from_id(id : int) -> void:
	var url = Global.SERVER_IP + "/photos/" + str(id)
	print("[HTTP REQUEST] url: ", url)
	# check if primary http_request is being used
	# if it is, create another HTTP Request Node
	
	var response = http_request.request(url)
	
	if response != 0:
		print("[HTTP REQUEST] No response")
		# if no response, create new HTTP Node
		var new_http_request := HTTPRequest.new()
		add_child(new_http_request)
		new_http_request.request_completed.connect(self.http_request_completed.bind(new_http_request, true))
		new_http_request.request(url)
		
		#new_http_request.queue_free()
	
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
		get_photo_size()

	
	if not Global.connect_to_api:
		print("[HTTP REQUEST] connect_to_api is false, removing self from scene")
		get_parent().remove_child(self)
		queue_free()
		return

	print("[HTTP REQUEST] Start")
	
