extends Node

enum State {}

@export var points: Dictionary[Enemy.Type, int] = { Enemy.Type.GHOST: 300, Enemy.Type.SLIME: 200 }

@onready var game: GameManager = $Game

var _score: int = 0
var _run_score: int = 0
var _skills: Array[Mechanic.Type] = [
	Mechanic.Type.CLIMB,
	Mechanic.Type.DASH,
	Mechanic.Type.DOUBLE_JUMP,
	Mechanic.Type.FLY,
	Mechanic.Type.KILL,
]
var _first_time: bool = true


func _init() -> void:
	SignalBus.level_completed.connect(_handle_on_complete)
	SignalBus.game_failed.connect(_handle_on_fail)
	SignalBus.enemy_killed.connect(_handle_enemy_kill)
	SignalBus.player_receive_dmg.connect(_handle_player_dmg)
	SignalBus.game_start.connect(_handle_game_start)


func _ready() -> void:
	game.stop()


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
	_skills = [
		Mechanic.Type.CLIMB,
		Mechanic.Type.DASH,
		Mechanic.Type.DOUBLE_JUMP,
		Mechanic.Type.FLY,
		Mechanic.Type.KILL,
	]

	game.call_deferred("stop")


func _handle_on_complete() -> void:
	_run_score = 0

	var type: Mechanic.Type = _skills.pick_random()

	_skills.remove_at(_skills.find(type))

	SignalBus.remove_mechanic.emit(type)

	game.reset()


func _handle_game_start() -> void:
	if _first_time:
		_first_time = false
		game.start()
	else:
		game.restart()
