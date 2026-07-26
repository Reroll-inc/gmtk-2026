extends Mechanic
class_name Dash

@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.18
@export var dash_cooldown: float = 0.4

@export var dash_sound: AudioStream = preload("res://assets/sfx/powerup03.mp3")

var _time_left: float = 0.0
var _cooling_down: bool = false
var _dir: Vector2 = Vector2.ZERO

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.wait_time = dash_cooldown


func can_activate() -> bool:
	if _cooling_down:
		return false
	return Input.is_action_just_pressed("dash")


func on_enter() -> void:
	var dir: Vector2 = player.read_input_direction()
	_dir = dir if dir != Vector2.ZERO else player.last_facing

	_time_left = dash_duration
	_cooling_down = true
	timer.start()
	player.velocity = _dir * dash_speed


func on_physics_process(delta: float) -> bool:
	_time_left -= delta
	player.velocity = _dir * dash_speed
	_play_dash()
	return _time_left > 0.0


func _play_dash() -> void:
	if player.audio_player.playing:
		player.audio_player.stop()
	player.audio_player.stream = dash_sound
	player.audio_player.pitch_scale = randf_range(0.9, 1.1)
	player.audio_player.play()


func _on_timer_timeout() -> void:
	_cooling_down = false
