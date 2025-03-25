extends Control

@export var topheader : RichTextLabel
@export var description : RichTextLabel
@export var tags : RichTextLabel
@export var details : RichTextLabel
@export var date : RichTextLabel
@export var path : RichTextLabel

func _ready() -> void:
	SignalBus.connect("_photo_tile_clicked", update_details)
	
func update_details(photo : PhotoTile):
	print("[INFO_BOX, update_details] called")
	pass
