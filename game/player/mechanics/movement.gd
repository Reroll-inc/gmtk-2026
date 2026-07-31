extends Mechanic
class_name BaseMovement

var _step_timer: float = 0.0
var _footstep_sound: AudioStream = preload("res://assets/sfx/putting_shoes.mp3")
var _jump_sound: AudioStream = preload("res://assets/sfx/jump12.mp3")


func is_interruptible() -> bool:
	return true


# base movement is always active
func on_physics_process(delta: float) -> bool:
	var hor: float = Input.get_action_strength("move_right") - Input.get_action_strength(
		"move_left"
	)
	var acc: float = (
		_player.PROPERTIES.movement_acceleration if _player.is_on_floor() else _player
		.PROPERTIES
		.air_acceleration
	)
	var velocity_weight: float = delta * (acc if hor else _player.PROPERTIES.movement_friction)

	_player.velocity.x = lerp(
		_player.velocity.x,
		hor * _player.PROPERTIES.movement_max_speed,
		velocity_weight,
	)

	if _player.is_on_floor():
		if Input.is_action_just_pressed("move_forward"):
			_player.velocity.y = _player.PROPERTIES.jump_height
			_play_jump()
			_player.set_anim("jump_start")
		else:
			_play_step(delta)
			_player.set_anim("run" if absf(_player.velocity.x) > 10.0 else "idle")
	elif _player.velocity.y < 0.0:
		_player.set_anim("fall")
		if Input.is_action_just_released("move_forward"):
			_player.velocity.y *= _player.PROPERTIES.jump_hold
		elif Input.is_action_pressed("move_back"):
			_player.velocity.y += _player.PROPERTIES.fast_fall_gravity * delta

	_player.velocity.y += _player.PROPERTIES.gravity

	return true


func _play_step(delta: float) -> void:
	_step_timer -= delta

	if _step_timer > 0.0 or absf(_player.velocity.x) < 10.0:
		return

	_step_timer = _player.PROPERTIES.movement_step_interval

	_player.audio_player.stream = _footstep_sound
	_player.audio_player.pitch_scale = randf_range(0.7, 1.3)
	_player.audio_player.play()


func _play_jump() -> void:
	if _player.audio_player.playing:
		_player.audio_player.stop()

	_player.audio_player.stream = _jump_sound
	_player.audio_player.pitch_scale = randf_range(0.9, 1.1)
	_player.audio_player.play()
