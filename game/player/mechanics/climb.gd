extends Mechanic
class_name Climb

var _step_timer: float = 0.0
var _climb_sound: AudioStream = preload("res://assets/sfx/poka02.mp3")


func can_activate() -> bool:
	return _active && _player.is_on_wall() and Input.is_action_pressed("climb")


# i want to allow the player to dash out of a climb, but not allow base movement to interrupt it...
func is_interruptible() -> bool:
	return true


func is_interruptible_by(_m: Mechanic) -> bool:
	return !(_m is BaseMovement)


func on_physics_process(_delta: float) -> bool:
	if not Input.is_action_pressed("climb") or not _player.is_on_wall():
		return false

	var dir: Vector2 = _player.read_input_direction()
	# +1 = wall on the right, -1 = on the left
	var wall_dir: float = -_player.get_wall_normal().x
	var facing = Vector2(wall_dir, 0.0)

	if dir.y != 0.0:
		_play_climb(_delta)
		_player.set_anim("climb_move", facing)
	else:
		_player.set_anim("climb_idle", facing)

	_player.velocity.y = dir.y * _player.PROPERTIES.climb_speed

	return true


func _play_climb(delta: float) -> void:
	_step_timer -= delta

	if _step_timer > 0.0 or absf(_player.velocity.y) < 10.0:
		return

	_step_timer = _player.PROPERTIES.climb_step_interval

	_player.audio_player.stream = _climb_sound
	_player.audio_player.pitch_scale = randf_range(0.7, 0.8)
	_player.audio_player.play()
