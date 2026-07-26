extends Node2D
class_name GameManager

@export var disposed_skills: Array[Mechanic.Type] = []

@onready var _start: Marker2D = $Start
@onready var _credits: Marker2D = $Credits
@onready var _player: Player = $TileMapLayers/TheThing/Player
@onready var _enemies: Array[Node] = $TileMapLayers/TheThing/Integrations.get_children()
@onready var _credits_area: CollisionShape2D = $TileMapLayers/Credits/FinishLine/CollisionShape2D


func _init() -> void:
	SignalBus.player_receive_dmg.connect(_handle_player_receive_dmg)
	SignalBus.remove_mechanic.connect(_handle_skill_removal)
	SignalBus.game_completed.connect(_handle_game_complete)


func _exit_tree() -> void:
	SignalBus.player_receive_dmg.disconnect(_handle_player_receive_dmg)
	SignalBus.remove_mechanic.disconnect(_handle_skill_removal)
	SignalBus.game_completed.disconnect(_handle_game_complete)


func _ready() -> void:
	_player.pause()

	for type in disposed_skills:
		_player.remove_mechanic(type)


func _handle_player_receive_dmg() -> void:
	_reset()


func _handle_skill_removal(type: Mechanic.Type) -> void:
	disposed_skills.push_back(type)


func _reset() -> void:
	disposed_skills.clear()

	_player.reset(Player.Position.START, _start)

	for enemy in _enemies:
		enemy.call_deferred("restore")


func stop() -> void:
	process_mode = PROCESS_MODE_DISABLED
	_player.pause()
	hide()


func start() -> void:
	_reset()
	_player.unpause()
	show()
	process_mode = PROCESS_MODE_INHERIT


func pause() -> void:
	process_mode = PROCESS_MODE_DISABLED
	_player.pause()


func unpause() -> void:
	process_mode = PROCESS_MODE_INHERIT


func _handle_game_complete() -> void:
	for enemy in _enemies:
		enemy.call_deferred("kill")

	show()
	unpause()

	_player.reset(Player.Position.CREDITS, _credits)
	_credits_area.disabled = false


func _on_finish_line_body_entered(_body: Node2D) -> void:
	_credits_area.set_deferred("disabled", true)
	call_deferred("stop")

	SignalBus.to_main_menu.emit()
