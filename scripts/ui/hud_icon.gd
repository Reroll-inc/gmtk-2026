extends TextureRect
class_name HudIcon

@export var type: Mechanic.Type
@export var image: Texture

@onready var _skill: TextureRect = $Icon

var active: CompressedTexture2D = preload("res://ui/hud_icon_1.tres")
var disactive: CompressedTexture2D = preload("res://ui/hud_icon_0.tres")


func _ready() -> void:
	_skill.texture = image

	texture = active


func complete() -> void:
	texture = disactive


func clear() -> void:
	texture = active
