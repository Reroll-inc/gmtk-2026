extends CanvasLayer

var main_menu: MainMenu = preload("res://ui/main_menu.tscn").instantiate()
var control_menu: ControlMenu = preload("res://ui/controls.tscn").instantiate()
var game_over: GameOver = preload("res://ui/game_over.tscn").instantiate()
var level_complete: LevelComplete = preload("res://ui/level_complete.tscn").instantiate()

@onready var hud: Hud = $Hud


func _init() -> void:
	SignalBus.game_start.connect(_handle_game_start)
	SignalBus.game_failed.connect(_handle_on_fail)
	SignalBus.level_completed.connect(_handle_level_completed)
	SignalBus.to_next_level.connect(_handle_to_next_level)
	SignalBus.to_main_menu.connect(_handle_game_to_main_menu)
	SignalBus.game_completed.connect(_handle_credits)

	main_menu.to_controls.connect(_handle_to_controls)
	control_menu.back.connect(_handle_controls_to_main_menu)
	game_over.to_menu.connect(_handle_game_over_to_main_menu)


func _ready() -> void:
	add_child(main_menu)


func _handle_game_start() -> void:
	hud.show()

	if main_menu.get_parent() != null:
		remove_child(main_menu)
	if game_over.get_parent() != null:
		remove_child(game_over)


func _handle_game_to_main_menu() -> void:
	add_child(main_menu)


func _handle_to_controls() -> void:
	remove_child(main_menu)
	add_child(control_menu)


func _handle_controls_to_main_menu() -> void:
	remove_child(control_menu)
	add_child(main_menu)


func _handle_on_fail() -> void:
	add_child(game_over)


func _handle_game_over_to_main_menu() -> void:
	remove_child(game_over)
	add_child(main_menu)


func _handle_level_completed() -> void:
	add_child(level_complete)

	level_complete.shuffle()


func _handle_to_next_level() -> void:
	remove_child(level_complete)


func _handle_credits() -> void:
	hud.hide()

	remove_child(level_complete)
