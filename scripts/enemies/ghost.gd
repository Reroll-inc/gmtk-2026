extends Node2D
class_name Ghost

@export var speed: float = 1.0
@export var vertical: bool = true
@export var distance: float = -120.0

@onready var _animator: AnimationPlayer = $AnimationPlayer
@onready var _hitbox_collision: CollisionShape2D = $Sprite/Hitbox/CollisionShape2D

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@export var sfx: AudioStream = preload(
	"res://assets/sfx/ghost_loop.ogg"
)
@export var sfx_distance_cutoff: float = 200.0
@export var sfx_attenuation: float = 2.0

func _ready() -> void:
	_preset_animation()

	_animator.play("ghost/fly-v" if vertical else "ghost/fly-h", -1, speed)

	audio_player.stream = sfx
	audio_player.max_distance = sfx_distance_cutoff
	audio_player.attenuation = sfx_attenuation
	audio_player.play()


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

	lib.remove_animation("fly-v" if vertical else "fly-h")
	lib.add_animation("fly-v" if vertical else "fly-h", anim)

	_animator.remove_animation_library("ghost")
	_animator.add_animation_library("ghost", lib)


func kill() -> void:
	hide()

	_hitbox_collision.disabled = true

	process_mode = Node.PROCESS_MODE_DISABLED


func restore() -> void:
	show()

	_hitbox_collision.disabled = false
	process_mode = Node.PROCESS_MODE_ALWAYS
