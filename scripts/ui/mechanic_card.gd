extends Button
class_name MechanicCard

@export var type: Mechanic.Type
@export var image: Texture
@export var title: String
@export var description: String

@onready var _skill: TextureRect = $MarginContainer/VBoxContainer/Skill
@onready var _title: Label = $MarginContainer/VBoxContainer/Title
@onready var _description: RichTextLabel = $MarginContainer/VBoxContainer/Description


func _ready() -> void:
	_skill.texture = image
	_title.text = title
	_description.text = description


func _on_pressed() -> void:
	SignalBus.remove_mechanic.emit(type)
	SignalBus.to_next_level.emit()
