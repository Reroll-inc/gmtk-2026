extends CanvasLayer

@onready var hud: Hud = $Hud
@onready var game_over: GameOver = $GameOver
@onready var main_menu: MainMenu = $MainMenu
@onready var control_menu: ControlMenu = $Controls
@onready var level_complete: LevelComplete = $LevelComplete


func _init() -> void:
	SignalBus.game_start.connect(_handle_game_start)
	SignalBus.game_failed.connect(_handle_on_fail)
	SignalBus.level_completed.connect(_handle_level_completed)
	SignalBus.to_next_level.connect(_handle_to_next_level)
	SignalBus.to_main_menu.connect(_handle_game_to_main_menu)
	SignalBus.game_completed.connect(_handle_credits)


func _ready() -> void:
	main_menu.to_controls.connect(_handle_to_controls)
	game_over.to_menu.connect(_handle_game_over_to_main_menu)
	control_menu.back.connect(_handle_controls_to_main_menu)

	main_menu.show()


func _handle_game_start() -> void:
	hud.show()
	game_over.hide()
	main_menu.hide()


func _handle_game_to_main_menu() -> void:
	main_menu.show()


func _handle_to_controls() -> void:
	main_menu.hide()
	control_menu.show()


func _handle_controls_to_main_menu() -> void:
	control_menu.hide()
	main_menu.show()


func _handle_on_fail() -> void:
	game_over.show()


func _handle_game_over_to_main_menu() -> void:
	game_over.hide()
	main_menu.show()


func _handle_level_completed() -> void:
	level_complete.show()
	level_complete.shuffle()


func _handle_to_next_level() -> void:
	level_complete.hide()


func _handle_credits() -> void:
	hud.hide()
	level_complete.hide()
