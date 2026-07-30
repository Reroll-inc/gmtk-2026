extends Node2D
class_name Ghost

@export var speed: float = 1.0
@export var vertical: bool = true
@export var distance: float = -120.0
@export var sleep_time: float

@onready var _animator: AnimationPlayer = $AnimationPlayer
@onready var _hitbox_collision: CollisionShape2D = $Sprite/Hitbox/CollisionShape2D
@onready var _audio_player: AudioStreamPlayer2D = $Sprite/AudioStreamPlayer2D


func _ready() -> void:
	_preset_animation()

	_animator.play("ghost/fly-v" if vertical else "ghost/fly-h", -1, speed)

	_audio_player.pitch_scale = randf_range(0.9, 1.1)


# This code should always expect the enemy to collide against the player.
# Nothing else is going to hit it as part of the hitbox, so it is safe.
func _on_hitbox_body_entered(player: Player) -> void:
	player.on_enemy_hit(self, Enemy.Type.GHOST)


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

	if sleep_time > 0:
		_add_sleep(anim)

	lib.remove_animation("fly-v" if vertical else "fly-h")
	lib.add_animation("fly-v" if vertical else "fly-h", anim)

	_animator.remove_animation_library("ghost")
	_animator.add_animation_library("ghost", lib)


func _add_sleep(anim: Animation) -> void:
	var keys: int = anim.track_get_key_count(0)
	var time: float = anim.track_get_key_time(0, keys - 1)
	anim.track_insert_key(0, time + sleep_time, Vector2(0, 0))

	anim.length += sleep_time


func kill() -> void:
	stop()
	hide()

	_hitbox_collision.disabled = true

	process_mode = Node.PROCESS_MODE_DISABLED


func restore() -> void:
	start()
	show()

	_hitbox_collision.disabled = false

	process_mode = Node.PROCESS_MODE_INHERIT


func stop() -> void:
	_animator.stop()
	_audio_player.stop()

func start() -> void:
	_animator.play()
	_audio_player.play()
