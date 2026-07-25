extends Node2D
class_name GameManager

@export var disposed_skills: Array[Mechanic.Type] = []

@onready var _start: Node2D = $Start
@onready var _player: Player = $TileMapLayers/Node2D/Player
@onready var _enemies: Array[Node] = $TileMapLayers/Node2D/Integrations.get_children()


func _init() -> void:
	SignalBus.player_receive_dmg.connect(_handle_player_receive_dmg)
	SignalBus.remove_mechanic.connect(_handle_skill_removal)


func _ready() -> void:
	_reset()

	for type in disposed_skills:
		_player.remove_mechanic(type)


func _handle_on_die() -> void:
	_reset()


func _handle_on_complete() -> void:
	_reset()


# This could be managed by the player and just get hit
# and animate the dmged state?
func _handle_player_receive_dmg() -> void:
	_reset()


func _handle_skill_removal(type: Mechanic.Type) -> void:
	disposed_skills.push_back(type)


func _reset() -> void:
	_player.position = _start.position

	for enemy in _enemies:
		enemy.call_deferred("restore")


# TODO
func finish() -> void:
	hide()


# TODO
func reset() -> void:
	show()
