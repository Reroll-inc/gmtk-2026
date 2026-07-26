extends Button
class_name ScoreCard


func _on_pressed() -> void:
	SignalBus.game_completed.emit()
