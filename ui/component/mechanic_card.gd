extends PanelContainer
class_name MechanicCard

@onready var label : RichTextLabel = $VBoxContainer/RichTextLabel
@onready var texture: TextureRect = $VBoxContainer/TextureRect

func setup(name: String) -> void:
	label.text = name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
