class_name DoubleJump
extends Mechanic

var _jumps_used: int = 0
var _jump_sound: AudioStream = preload("res://assets/sfx/jump12.mp3")


func can_activate() -> bool:
	if !_active:
		return false

	# i need a way to reset the jump once the _player touches the ground again
	# and a way around that is to just have a separate physics process for that
	if _player.is_on_floor():
		_jumps_used = 0

	return (
		not _player.is_on_floor() and Input.is_action_just_pressed("move_forward")
		and _jumps_used < _player.PROPERTIES.double_jump_max
	)


func on_physics_process(_delta: float) -> bool:
	_jumps_used += 1
	_player.velocity.y = _player.PROPERTIES.jump_height

	_play_jump()
	_player.set_anim("jump_start")

	return false


func _play_jump() -> void:
	if _player.audio_player.playing:
		_player.audio_player.stop()

	_player.audio_player.stream = _jump_sound
	_player.audio_player.pitch_scale = randf_range(1.4, 1.7)
	_player.audio_player.play()
