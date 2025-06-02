extends Node

@export var SERVER_IP : String = "http://127.0.0.1:8000"
@export var test_mode : bool = false

@onready var http_request : HTTPRequest = HTTPRequest.new() # preload 1 http request
@onready var img := Image.new()

var queue_id = []

func get_photo_from_id(id : int) -> void:
	var url = SERVER_IP + "/photos/" + str(id)
	print("[HTTP REQUEST] url: ", url)
	# check if primary http_request is being used
	# if it is, create another HTTP Request Node
	
	http_request.request(url)
	

func http_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
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
	
	
	
func _ready():
	# connect the first (primary) HTTP
	http_request.request_completed.connect(self.http_request_completed)
	add_child(http_request)
	
	if test_mode:
		print("[HTTP REQUEST] Test")
		Global.connect_to_api = true
		get_photo_from_id(1)
		get_photo_from_id(2)

	
	if not Global.connect_to_api:
		print("[HTTP REQUEST] connect_to_api is false, removing self from scene")
		get_parent().remove_child(self)
		queue_free()
		return

	print("[HTTP REQUEST] Start")
	
