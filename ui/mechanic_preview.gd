extends Button
class_name MechanicPreview

@export var type: Mechanic.Type
@export var image: Texture
@export var title: String

@onready var _skill: TextureRect = $MarginContainer/VBoxContainer/Icon
@onready var _title: Label = $MarginContainer/VBoxContainer/Title


func _ready() -> void:
	_skill.texture = image
	_title.text = title
