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
	path.clear()
	path.append_text("[color=black]{path}[/color]".format({
		"path":photo.path
	}))
	date.clear()
	date.append_text("[color=black]{date}[/color]".format({
		"date":photo.date
	}))
	#tags.clear()
	#tags.append_text("[color=black]{tags}[/color]".format({
	#	"tags":photo.tags
	#}))
	description.clear()
	description.append_text("[color=black]{description}[/color]".format({
		"description":photo.description
	}))
