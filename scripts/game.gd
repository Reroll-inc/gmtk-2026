extends Node2D
class_name GameManager

@onready var _start: Node2D = $Start
@onready var _player: Player = $Player


func _ready() -> void:
	_player.position = _start.position


func _handle_on_die() -> void:
	_player.position = _start.position
