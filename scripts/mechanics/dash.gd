class_name Dash
extends Mechanic

@export var dash_speed: float = 800.0
@export var dash_duration: float = 0.18
@export var dash_cooldown: float = 0.4

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

func _read_input_direction() -> Vector2:
	var hor: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var ver: float = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	return Vector2(hor, ver).normalized()

func on_enter() -> void:
	_dir = _read_input_direction()
	_time_left = dash_duration
	_cooling_down = true
	timer.start()
	player.velocity = _dir * dash_speed

func on_physics_process(delta: float) -> bool:
	_time_left -= delta
	player.velocity = _dir * dash_speed
	return _time_left > 0.0 # we dash until the time is up

func _on_timer_timeout() -> void:
	_cooling_down = false
