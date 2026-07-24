class_name BaseMovement
extends Mechanic

@export var jump_height: float = -450.0
@export var gravity: float = 20.5
@export var jump_hold: float = 0.5
@export var fast_fall_gravity: float = 600.0

@export var max_speed: float = 400.0
@export var acceleration: float = 52.5
@export var friction: float = 12.5

@export var air_acceleration: float = 10.0

func can_interrupt() -> bool:
	return true

func on_physics_process(delta: float) -> bool:
	var hor: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var acc: float = acceleration if player.is_on_floor() else air_acceleration
	var velocity_weight: float = delta * (acc if hor else friction)

	player.velocity.x = lerp(player.velocity.x, hor * max_speed, velocity_weight)

	if player.is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			player.velocity.y = jump_height
	elif player.velocity.y < 0.0:
		if Input.is_action_just_released("ui_up"):
			player.velocity.y *= jump_hold
		elif Input.is_action_pressed("ui_down"):
			player.velocity.y += fast_fall_gravity * delta

	player.velocity.y += gravity
	return true # base movement is always active