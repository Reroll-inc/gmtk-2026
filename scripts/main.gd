extends Node

enum State {}

@onready var game: GameManager = $Game

var _skills: Array[Mechanic.Type] = [
	Mechanic.Type.CLIMB,
	Mechanic.Type.DASH,
	Mechanic.Type.DOUBLE_JUMP,
	Mechanic.Type.FLY,
	Mechanic.Type.KILL,
]


func _init() -> void:
	SignalBus.level_completed.connect(_handle_on_complete)
	SignalBus.game_failed.connect(_handle_on_fail)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.show()


func _handle_on_fail() -> void:
	_skills = [
		Mechanic.Type.CLIMB,
		Mechanic.Type.DASH,
		Mechanic.Type.DOUBLE_JUMP,
		# Mechanic.Type.FLY,
		Mechanic.Type.KILL,
	]

	game.call_deferred("reload")


func _handle_on_complete() -> void:
	var type: Mechanic.Type = _skills.pick_random()

	_skills.remove_at(_skills.find(type))

	SignalBus.remove_mechanic.emit(type)

	game.reset()
