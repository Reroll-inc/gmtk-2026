extends Control
class_name LevelComplete

@onready var deck: Array[Node] = $SkillCards.get_children()

var available_skills: Array = Mechanic.Type.values()


func _ready() -> void:
	SignalBus.remove_mechanic.connect(_handle_skill_removal)
	SignalBus.game_start.connect(_handle_skill_reset)

	_handle_skill_reset()


func shuffle() -> void:
	if available_skills.size() == 0:
		return

	if available_skills.size() == 1:
		var last: Mechanic.Type = available_skills[0]

		for card: MechanicCard in deck:
			if card.type == last:
				card.visible = true
				break

		return

	var left: Mechanic.Type = available_skills[randi() % available_skills.size()]
	var right: Mechanic.Type = available_skills[randi() % available_skills.size()]

	while left == right:
		right = available_skills[randi() % available_skills.size()]

	for card: MechanicCard in deck:
		card.visible = card.type == left or card.type == right


func _handle_skill_reset() -> void:
	available_skills = Mechanic.Type.values()

	for card: MechanicCard in deck:
		card.visible = false


func _handle_skill_removal(type: Mechanic.Type) -> void:
	available_skills.erase(type)

	for card: MechanicCard in deck:
		if card.type == type:
			card.visible = false
			break
