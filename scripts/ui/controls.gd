extends Control
class_name ControlMenu

signal back()


func _on_back_pressed() -> void:
	back.emit()
