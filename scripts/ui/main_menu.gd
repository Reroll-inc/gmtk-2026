extends Control


func _on_play_pressed() -> void:
	SignalBus.game_start.emit()
