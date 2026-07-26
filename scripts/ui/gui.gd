extends Control

var main_menu = preload("res://ui/main_menu.tscn").instantiate()


func _init() -> void:
	SignalBus.game_start.connect(_handle_game_start)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().root.call_deferred("add_child", main_menu)


func _handle_game_start() -> void:
	get_tree().root.call_deferred("remove_child", main_menu)
