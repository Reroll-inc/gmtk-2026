class_name DoubleJump
extends Mechanic

var max_jumps: int = 1
var _jumps_used: int = 0

func can_activate() -> bool:
	if (
		not player.is_on_floor() and
		Input.is_action_just_pressed("ui_up") and
		_jumps_used < max_jumps
		):
		return true
	return false

func on_physics_process(_delta: float) -> bool:
	_jumps_used += 1
	player.velocity.y = player.jump_height
	return false

# i need a way to reset the jump once the player touches the ground again
# and a way around that is to just have a separate physics process for that
func _physics_process(_delta: float) -> void:
	if player.is_on_floor():
		_jumps_used = 0
