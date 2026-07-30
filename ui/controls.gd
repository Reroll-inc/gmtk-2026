extends Control
class_name ControlMenu

signal back()

@onready var video: VideoStreamPlayer = $TextureRect/VBoxContainer2/VideoStreamPlayer
@onready var label: Label = $TextureRect/VBoxContainer2/Label4

const PREVIEWS := {
	"double_jump": preload("res://assets/previews/double_jump.ogv"),
	"dash": preload("res://assets/previews/dash.ogv"),
	"climb": preload("res://assets/previews/climb.ogv"),
	"fly": preload("res://assets/previews/fly.ogv"),
	"kill": preload("res://assets/previews/kill.ogv"),
}

func _ready() -> void:
	for row: Control in $VBoxContainer.get_children():
		row.mouse_entered.connect(_show_preview.bind(row.name))
		for child: Control in row.find_children("*", "Control", true, false):
			child.mouse_entered.connect(_show_preview.bind(row.name))

	video.finished.connect(video.play)   # VideoStreamPlayer has no loop flag; replay on finish

func _show_preview(mechanic: StringName) -> void:
	var stream: VideoStream = PREVIEWS.get(String(mechanic))
	if stream == null:
		return
	video.stream = stream
	video.play()
	label.text = String(mechanic)

func _on_back_pressed() -> void:
	back.emit()
