class_name Fly
extends Mechanic

@export var fly_speed: float = 200.0

@export var flap_interval: float = 1.0
var _flap_timer: float = 0.0
@export var flap_sound: AudioStream = preload("res://assets/sfx/flap.ogg")


func can_activate() -> bool:
	if Input.is_action_pressed("fly"):
		return true
	return false


func on_physics_process(delta: float) -> bool:
	if not Input.is_action_pressed("fly"):
		return false
	var dir: Vector2 = player.read_input_direction()

	player.velocity = dir * fly_speed
	_play_flap(delta, dir)

	return true


func _play_flap(delta: float, inp: Vector2) -> void:
	var extra = 1.0 if inp.length_squared() < 0.1 else 1.5
	_flap_timer -= delta * extra
	if _flap_timer > 0.0 or player.is_on_floor():
		return
	_flap_timer = flap_interval
	player.audio_player.stream = flap_sound
	player.audio_player.pitch_scale = randf_range(0.5, 1.5)
	player.audio_player.play()


func is_interruptible() -> bool:
	return true


func is_interruptible_by(_m: Mechanic) -> bool:
	# i want to allow the player to dash during flight,
	# but not allow base movement to interrupt it (unless they stopped pressing the fly button)
	return !(_m is BaseMovement)
