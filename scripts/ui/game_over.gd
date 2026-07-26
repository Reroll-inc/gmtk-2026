extends Control
class_name GameOver

signal to_menu()


func _on_to_menu_pressed() -> void:
	to_menu.emit()


func _on_to_play_pressed() -> void:
	SignalBus.game_start.emit()
