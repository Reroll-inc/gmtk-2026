extends CanvasLayer

@onready var mechanics_bar = $MechanicsBar

var mechanic_card = preload("res://ui/component/mechanic_card.tscn")


func _ready() -> void:
	for m in Global.player.mechanics.get_children():
		_add_mechanic_card(m.name)

	# im not really watching the player, im just listening to the same
	# mechanic remove signal as them
	SignalBus.remove_mechanic.connect(_on_remove_mechanic)


func _add_mechanic_card(mechanic_name: String) -> void:
	var card = mechanic_card.instantiate()
	card.name = mechanic_name
	mechanics_bar.add_child(card)
	var mcard = card as MechanicCard
	mcard.setup(mechanic_name)


func _on_remove_mechanic(type: Mechanic.Type) -> void:
	var mechanic_name: String = Mechanic.NODE_NAME[type]
	var card = mechanics_bar.get_node_or_null(mechanic_name)
	if card:
		card.queue_free()


func _on_button_pressed() -> void:
	SignalBus.remove_mechanic.emit(Mechanic.Type.CLIMB)
