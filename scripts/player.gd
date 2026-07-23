extends CharacterBody2D

@export var JUMP_HEIGHT := -450.0
@export var GRAVITY := 20.5
@export var JUMP_HOLD := 0.5
@export var FAST_FALL_GRAVITY := 600.0

@export var MAX_SPEED := 400.0
@export var ACCELERATION := 52.5
@export var FRICTION := 12.5

@export var AIR_ACCELERATION := 10.0

func _physics_process(delta: float) -> void:
	var hor := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var acc := ACCELERATION if is_on_floor() else AIR_ACCELERATION
	var velocity_weight := delta * (acc if hor else FRICTION)
	velocity.x = lerp(velocity.x, hor * MAX_SPEED, velocity_weight)
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_HEIGHT
	elif velocity.y < 0.0:
		if Input.is_action_just_released("ui_up"):
			velocity.y *= JUMP_HOLD
		elif Input.is_action_pressed("ui_down"):
			velocity.y += FAST_FALL_GRAVITY * delta
	
	velocity.y += GRAVITY
	move_and_slide()
