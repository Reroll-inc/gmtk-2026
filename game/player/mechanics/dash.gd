extends Mechanic
class_name Dash

var _dash_sound: AudioStream = preload("res://assets/sfx/powerup03.mp3")
var _time_left: float = 0.0
var _cooling_down: bool = false
var _dir: Vector2 = Vector2.ZERO
var _timer: Timer = Timer.new()


func _init(player: Player) -> void:
	super(player)

	_timer.name = "DashTimer"

	player.add_child(_timer)

	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	_timer.wait_time = player.PROPERTIES.dash_cooldown


func free() -> void:
	super()

	_timer.queue_free()


func can_activate() -> bool:
	return _active && !_cooling_down && Input.is_action_just_pressed("dash")


func on_enter() -> void:
	var dir: Vector2 = _player.read_input_direction()
	_dir = dir if dir != Vector2.ZERO else _player.last_facing
	#todo: dash anim
	_player.set_anim("fall")

	_time_left = _player.PROPERTIES.dash_duration
	_cooling_down = true
	_timer.start()
	_player.velocity = _dir * _player.PROPERTIES.dash_speed


func on_physics_process(delta: float) -> bool:
	_time_left -= delta
	_player.velocity = _dir * _player.PROPERTIES.dash_speed
	_play_dash()
	return _time_left > 0.0


func _play_dash() -> void:
	if _player.audio_player.playing:
		_player.audio_player.stop()

	_player.audio_player.stream = _dash_sound
	_player.audio_player.pitch_scale = randf_range(0.9, 1.1)
	_player.audio_player.play()


func _on_timer_timeout() -> void:
	_cooling_down = false
