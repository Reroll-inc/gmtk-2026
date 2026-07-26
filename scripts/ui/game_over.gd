extends Control
class_name GameOver

signal to_menu()

@onready var _mechanic_list: Array[Node] = $VBoxContainer2/MechanicList.get_children()


func _init() -> void:
	SignalBus.remove_mechanic.connect(_handle_remove_mechanic)
	SignalBus.game_start.connect(_clean_up)


func _ready() -> void:
	_clean_up()


func _handle_remove_mechanic(type: Mechanic.Type) -> void:
	for mechanic: MechanicPreview in _mechanic_list:
		if mechanic.type == type:
			mechanic.disabled = true

			break


func _on_to_menu_pressed() -> void:
	to_menu.emit()


func _on_to_play_pressed() -> void:
	SignalBus.game_start.emit()


func _clean_up() -> void:
	for mechanic: MechanicPreview in _mechanic_list:
		mechanic.disabled = false
