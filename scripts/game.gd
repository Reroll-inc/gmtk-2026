extends Node2D
class_name GameManager

@onready var _start: Node2D = $Start
@onready var _player: Player = $TileMapLayers/Node2D/Player


func _init() -> void:
	SignalBus.player_receive_dmg.connect(_handle_player_receive_dmg)


func _exit_tree() -> void:
	SignalBus.player_receive_dmg.disconnect(_handle_player_receive_dmg)


func _ready() -> void:
	_reset_player()


func _handle_on_die() -> void:
	_reset_player()


func _handle_on_complete() -> void:
	_reset_player()


# This could be managed by the player and just get hit
# and animate the dmged state?
func _handle_player_receive_dmg() -> void:
	_reset_player()


func _reset_player() -> void:
	_player.position = _start.position
