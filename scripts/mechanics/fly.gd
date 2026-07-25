class_name Fly
extends Mechanic

@export var fly_speed: float = 200.0

func can_activate() -> bool:
	if Input.is_action_pressed("fly"):
		return true
	return false

func on_physics_process(_delta: float) -> bool:
	if not Input.is_action_pressed("fly"):
		return false
	var dir: Vector2 = player.read_input_direction()

	player.velocity = dir * fly_speed

	return true

func is_interruptible() -> bool:
	return true

func is_interruptible_by(_m: Mechanic) -> bool:
	# i want to allow the player to dash during flight,
	# but not allow base movement to interrupt it (unless they stopped pressing the fly button)
	return !(_m is BaseMovement)
