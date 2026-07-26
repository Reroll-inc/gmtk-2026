extends Mechanic
class_name BaseMovement

@export var step_interval: float = 0.3
var _step_timer: float = 0.0
@export var footstep_sound: AudioStream = preload("res://assets/sfx/putting_shoes.mp3")
@export var jump_sound: AudioStream = preload("res://assets/sfx/jump12.mp3")


func is_interruptible() -> bool:
	return true


# base movement is always active
func on_physics_process(delta: float) -> bool:
	var hor: float = (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	var acc: float = (player.acceleration if player.is_on_floor() else player.air_acceleration)
	var velocity_weight: float = delta * (acc if hor else player.friction)

	player.velocity.x = lerp(player.velocity.x, hor * player.max_speed, velocity_weight)

	if player.is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			player.velocity.y = player.jump_height
			_play_jump()
			player.set_anim("jump_start")
		else:
			_play_step(delta)
			player.set_anim("run" if absf(player.velocity.x) > 10.0 else "idle")
	elif player.velocity.y < 0.0:
		player.set_anim("fall")
		if Input.is_action_just_released("ui_up"):
			player.velocity.y *= player.jump_hold
		elif Input.is_action_pressed("ui_down"):
			player.velocity.y += player.fast_fall_gravity * delta

	player.velocity.y += player.gravity

	return true


func _play_step(delta: float) -> void:
	_step_timer -= delta
	if _step_timer > 0.0 or absf(player.velocity.x) < 10.0:
		return
	_step_timer = step_interval
	player.audio_player.stream = footstep_sound
	player.audio_player.pitch_scale = randf_range(0.7, 1.3)
	player.audio_player.play()


func _play_jump() -> void:
	if player.audio_player.playing:
		player.audio_player.stop()
	player.audio_player.stream = jump_sound
	player.audio_player.pitch_scale = randf_range(0.9, 1.1)
	player.audio_player.play()
