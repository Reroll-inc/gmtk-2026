extends Node

enum State {}

@onready var game: GameManager = $Game


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.show()


func _on_next_level() -> void:
	game.reset()
