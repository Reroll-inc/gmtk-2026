extends Control
class_name MainMenu

signal to_controls()


func _on_play_pressed() -> void:
	SignalBus.game_start.emit()


func _on_controls_pressed() -> void:
	to_controls.emit()
