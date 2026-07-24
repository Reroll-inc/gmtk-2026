extends Node2D
class_name GameManager

@onready var _start: Node2D = $Start
@onready var _player: Player = $TileMapLayers/Node2D/Player


func _init() -> void:
	SignalBus.enemy_hit.connect(_handle_on_enemy_hit)


func _exit_tree() -> void:
	SignalBus.enemy_hit.disconnect(_handle_on_enemy_hit)


func _ready() -> void:
	_reset_player()


func _handle_on_die() -> void:
	_reset_player()


func _handle_on_complete() -> void:
	_reset_player()


func _handle_on_enemy_hit(_enemy: Enemy) -> void:
	if _player.velocity.y > 0:
		_player.velocity.y = -300
		_enemy.queue_free()
	else:
		_reset_player()


func _reset_player() -> void:
	_player.position = _start.position
