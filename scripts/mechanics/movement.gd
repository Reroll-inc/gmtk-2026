extends Mechanic
class_name BaseMovement

func can_interrupt() -> bool:
	return true


# base movement is always active
func on_physics_process(delta: float) -> bool:
	var hor: float = (
		Input.get_action_strength("ui_right") -
		Input.get_action_strength("ui_left")
	)
	var acc: float = (
		player.acceleration if player.is_on_floor() else player.air_acceleration
	)
	var velocity_weight: float = delta * (acc if hor else player.friction)

	player.velocity.x = lerp(
		player.velocity.x,
		hor * player.max_speed,
		velocity_weight
	)

	if player.is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			player.velocity.y = player.jump_height
	elif player.velocity.y < 0.0:
		if Input.is_action_just_released("ui_up"):
			player.velocity.y *= player.jump_hold
		elif Input.is_action_pressed("ui_down"):
			player.velocity.y += player.fast_fall_gravity * delta

	player.velocity.y += player.gravity
	
	return true
