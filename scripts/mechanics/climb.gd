extends Mechanic
class_name Climb

@export var climb_speed: float = 200.0
@export var step_interval: float = 0.25
var _step_timer: float = 0.0
@export var climb_sound: AudioStream = preload("res://assets/sfx/poka02.mp3")


func can_activate() -> bool:
	if player.is_on_wall() and Input.is_action_pressed("climb"):
		return true
	return false


# i want to allow the player to dash out of a climb, but not allow base movement to interrupt it...
func is_interruptible() -> bool:
	return true


func is_interruptible_by(_m: Mechanic) -> bool:
	return !(_m is BaseMovement)


func on_physics_process(_delta: float) -> bool:
	if not Input.is_action_pressed("climb") or not player.is_on_wall():
		return false

	var dir: Vector2 = player.read_input_direction()

	if dir.y != 0.0:
		_play_climb(_delta)

	player.velocity.y = dir.y * climb_speed

	return true


func _play_climb(delta: float) -> void:
	_step_timer -= delta
	if _step_timer > 0.0 or absf(player.velocity.y) < 10.0:
		return
	_step_timer = step_interval
	player.audio_player.stream = climb_sound
	player.audio_player.pitch_scale = randf_range(0.7, 0.8)
	player.audio_player.play()
