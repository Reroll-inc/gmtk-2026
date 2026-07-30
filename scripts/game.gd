extends Node2D
class_name GameManager

@onready var _start: Marker2D = $Start
@onready var _credits: Marker2D = $Credits
@onready var _player: Player = $TileMapLayers/TheThing/Player
@onready var _enemies: Array[Node] = $TileMapLayers/TheThing/Integrations.get_children()
@onready var _credits_area: CollisionShape2D = $TileMapLayers/Credits/FinishLine/CollisionShape2D


func _init() -> void:
	SignalBus.player_receive_dmg.connect(_handle_player_receive_dmg)
	SignalBus.game_completed.connect(_handle_game_complete)
	SignalBus.game_failed.connect(_handle_game_failed)
	SignalBus.level_completed.connect(_handle_level_completed)
	SignalBus.game_start.connect(_handle_game_start)
	SignalBus.to_next_level.connect(_handle_game_start)


func _ready() -> void:
	_stop()
	_player.pause()


func _handle_player_receive_dmg() -> void:
	_reset()


func _reset() -> void:
	_player.reset(Player.Position.START, _start)

	for enemy in _enemies:
		enemy.call_deferred("restore")


func _stop() -> void:
	process_mode = PROCESS_MODE_DISABLED
	_player.pause()
	hide()


func _handle_game_start() -> void:
	_reset()
	_player.unpause()
	show()
	process_mode = PROCESS_MODE_INHERIT


func _handle_game_complete() -> void:
	for enemy in _enemies:
		enemy.call_deferred("kill")

	_player.reset(Player.Position.CREDITS, _credits)
	_credits_area.disabled = false
	show()

	process_mode = PROCESS_MODE_INHERIT


func _on_finish_line_body_entered(_body: Node2D) -> void:
	_credits_area.set_deferred("disabled", true)
	call_deferred("_stop")

	SignalBus.to_main_menu.emit()


func _handle_game_failed() -> void:
	call_deferred("_stop")


func _handle_level_completed() -> void:
	call_deferred("_stop")
