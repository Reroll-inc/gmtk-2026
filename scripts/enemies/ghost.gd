extends Node2D
class_name Ghost

@export var speed: float = 1.0
@export var vertical: bool = true
@export var distance: float = -120.0

@onready var _animator: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	_preset_animation()

	_animator.play("ghost/fly-v" if vertical else "ghost/fly-h", -1, speed)


# This code should always expect the enemy to collide against the player.
# Nothing else is going to hit it as part of the hitbox, so it is safe.
func _on_hitbox_body_entered(player: Player) -> void:
	if player.is_falling():
		player.bounce_up_on_hit_enemy()
		SignalBus.enemy_killed.emit()

		queue_free()
	else:
		SignalBus.player_receive_dmg.emit()


# Hardcoded property & keyframe
func _preset_animation() -> void:
	var lib: AnimationLibrary = _animator.get_animation_library("ghost").duplicate()
	var anim: Animation = lib.get_animation("fly-v" if vertical else "fly-h").duplicate()
	var value: Vector2 = Vector2()

	if vertical:
		value.y = distance
	else:
		value.x = distance

	anim.track_set_key_value(0, 1, value)

	lib.remove_animation("fly-v" if vertical else "fly-h")
	lib.add_animation("fly-v" if vertical else "fly-h", anim)

	_animator.remove_animation_library("ghost")
	_animator.add_animation_library("ghost", lib)
