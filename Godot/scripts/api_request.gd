extends Node

@export var SERVER_IP : String = "http://127.0.0.1:8000"
@export var http_request : HTTPRequest
@export var test_mode : bool = false

func get_photo_from_id(id : int) -> void:
	var url = SERVER_IP + "/photos/" + str(id)
	print("[HTTP REQUEST] url: ", url)
	http_request.request(url)
	

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("[HTTP REQUEST] result: {result} response code: {response_code} headers: {headers}\nbody: {body}".format(
		{
			"result": result,
			"response_code": response_code,
			"headers": headers,
			"body": "body",
		}
	))
	if test_mode:
		var img := Image.new()
		img.load_jpg_from_buffer(body)
		var sprite := Sprite2D.new()
		sprite.texture = ImageTexture.create_from_image(img)
		get_parent().add_child(sprite)
	
	
	
func _ready():
	if not Global.connect_to_api:
		print("[HTTP REQUEST] connect_to_api is false, removing self from scene")
		get_parent().remove_child(self)
		queue_free()
		return

	print("[HTTP REQUEST] Start")
	get_photo_from_id(2)
