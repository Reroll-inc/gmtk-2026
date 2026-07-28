extends Node

enum State {}

@export var points: Dictionary[Enemy.Type, int] = { Enemy.Type.GHOST: 300, Enemy.Type.SLIME: 200 }

@onready var game: GameManager = $Game

var _score: int = 0
var _run_score: int = 0


func _init() -> void:
	SignalBus.to_next_level.connect(_handle_to_next_level)
	SignalBus.game_failed.connect(_handle_on_fail)
	SignalBus.enemy_killed.connect(_handle_enemy_kill)
	SignalBus.player_receive_dmg.connect(_handle_player_dmg)


func _handle_enemy_kill(type: Enemy.Type) -> void:
	_run_score += points[type]
	_score += points[type]

	SignalBus.score_update.emit(_score)


func _handle_player_dmg() -> void:
	_score -= _run_score
	_run_score = 0

	SignalBus.score_update.emit(_score)


func _handle_on_fail() -> void:
	_score = 0
	_run_score = 0


func _handle_to_next_level() -> void:
	_run_score = 0
