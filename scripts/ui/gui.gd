extends CanvasLayer

var main_menu: MainMenu = preload("res://ui/main_menu.tscn").instantiate()
var control_menu: ControlMenu = preload("res://ui/controls.tscn").instantiate()
var game_over: GameOver = preload("res://ui/game_over.tscn").instantiate()
var level_complete: LevelComplete = preload("res://ui/level_complete.tscn").instantiate()


func _init() -> void:
	SignalBus.game_start.connect(_handle_game_start)
	SignalBus.game_failed.connect(_handle_on_fail)
	SignalBus.level_completed.connect(_handle_level_completed)
	SignalBus.to_next_level.connect(_handle_to_next_level)

	main_menu.to_controls.connect(_handle_to_controls)
	control_menu.back.connect(_handle_controls_to_main_menu)
	game_over.to_menu.connect(_handle_game_over_to_main_menu)


func _ready() -> void:
	get_tree().root.call_deferred("add_child", main_menu)


func _handle_game_start() -> void:
	get_tree().root.remove_child(main_menu)


func _handle_to_controls() -> void:
	get_tree().root.remove_child(main_menu)
	get_tree().root.add_child(control_menu)


func _handle_controls_to_main_menu() -> void:
	get_tree().root.remove_child(control_menu)
	get_tree().root.add_child(main_menu)


func _handle_on_fail() -> void:
	get_tree().root.add_child(game_over)


func _handle_game_over_to_main_menu() -> void:
	get_tree().root.remove_child(game_over)
	get_tree().root.add_child(main_menu)


func _handle_level_completed() -> void:
	get_tree().root.add_child(level_complete)
	level_complete.shuffle()


func _handle_to_next_level() -> void:
	get_tree().root.remove_child(level_complete)
