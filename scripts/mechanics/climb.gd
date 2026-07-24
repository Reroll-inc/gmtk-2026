extends Mechanic
class_name Climb

@export var climb_speed: float = 200.0

func can_activate() -> bool:
	if player.is_on_wall() and Input.is_action_pressed("climb"):
		return true
	return false

# i want to allow the player to dash out of a climb, but not allow base movement to interrupt it...
func is_interruptible() -> bool:
	return true

func is_interruptible_by(_m: Mechanic) -> bool:
	if _m is BaseMovement:
		# this is one case where we don't want to interrupt another mechanic
		return false
	return true

func on_physics_process(_delta: float) -> bool:
	if not Input.is_action_pressed("climb") or not player.is_on_wall():
		return false

	var dir = player.read_input_direction()

	player.velocity.y = dir.y * climb_speed

	return true
