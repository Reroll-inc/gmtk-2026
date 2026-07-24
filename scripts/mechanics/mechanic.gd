extends Node
class_name Mechanic

var player: Player

# because we want to reach info or nodes from the player
func setup(p: Player) -> void:
	player = p

# can we switch to this mechanic?
# exmaple: you can only Climb if you are touching a wall and pressing X
# or you can only Dash if you are pressing Z (and some cooldown timer?)
func can_activate() -> bool:
	return true

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass

# the physics loop for the mechanic
# returns true if the mechanic is still ongoing/being used
# returns false if the mechanic is over (end of stamina or needs cooldown)
func on_physics_process(_delta: float) -> bool:
	return false

# we can technically always use the base movement
# and that state never needs to end to switch to another mechanic
# so we can say there are states that can be interrupted and states that cannot
func is_interruptible() -> bool:
	return false

# wanna play rock paper scissors with the mechanics? 
func is_interruptible_by(_m: Mechanic) -> bool:
	return true
