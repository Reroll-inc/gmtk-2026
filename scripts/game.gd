extends Node2D
class_name GameManager

@export var disposed_skills: Array[Mechanic.Type] = []

@onready var _start: Node2D = $Start
@onready var _player: Player = $TileMapLayers/Node2D/Player
@onready var _enemies: Array[Node] = $TileMapLayers/Node2D/Integrations.get_children()


func _init() -> void:
	SignalBus.player_receive_dmg.connect(_handle_player_receive_dmg)
	SignalBus.remove_mechanic.connect(_handle_skill_removal)


func _exit_tree() -> void:
	SignalBus.player_receive_dmg.disconnect(_handle_player_receive_dmg)
	SignalBus.remove_mechanic.disconnect(_handle_skill_removal)


func _ready() -> void:
	_player.reset(_start)

	for type in disposed_skills:
		_player.remove_mechanic(type)


func _handle_player_receive_dmg() -> void:
	_reset()


func _handle_skill_removal(type: Mechanic.Type) -> void:
	disposed_skills.push_back(type)


func _reset() -> void:
	_player.reset(_start)

	for enemy in _enemies:
		enemy.call_deferred("restore")


# TODO
func finish() -> void:
	hide()


func reload() -> void:
	get_tree().reload_current_scene()


# TODO
func reset() -> void:
	show()
	_reset()
