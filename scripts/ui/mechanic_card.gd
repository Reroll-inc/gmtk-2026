extends Button
class_name MechanicCard

@export var type: Mechanic.Type


func _on_pressed() -> void:
	SignalBus.remove_mechanic.emit(type)
	SignalBus.to_next_level.emit()
