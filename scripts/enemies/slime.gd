extends CharacterBody2D
class_name Slime

@export var speed: float = 50.0
@export var step_interval: float = 0.5

@onready var _left_floor_check: RayCast2D = $LeftFloorCheck
@onready var _right_floor_check: RayCast2D = $RightFloorCheck
@onready var _sprite: AnimatedSprite2D = $Sprite
@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var _audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _direction: int = 1
var _gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var _step_timer: float = 0.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += _gravity * delta
	else:
		velocity.y = 0

	velocity.x = _direction * speed

	move_and_slide()

	_play_step(delta)

	if (
		is_on_wall()
		or is_on_floor()
		and (
			_direction == 1 and not _right_floor_check.is_colliding()
			or _direction == -1 and not _left_floor_check.is_colliding()
		)
	):
		_flip_direction()


func _play_step(delta: float) -> void:
	_step_timer -= delta
	if _step_timer > 0.0 or absf(velocity.x) < 10.0:
		return
	_step_timer = step_interval
	_audio_player.pitch_scale = randf_range(1.4, 1.6)
	_audio_player.play()


func _flip_direction() -> void:
	_direction *= -1
	_sprite.flip_h = !_sprite.flip_h


# This code should always expect the enemy to collide against the player.
# Nothing else is going to hit it as part of the hitbox, so it is safe.
func _on_hitbox_body_entered(player: Player) -> void:
	player.on_enemy_hit(self, Enemy.Type.SLIME)


func kill() -> void:
	stop()
	hide()

	_collision.disabled = true
	_hitbox_collision.disabled = true

	process_mode = Node.PROCESS_MODE_DISABLED


func restore() -> void:
	show()
	start()

	_collision.disabled = false
	_hitbox_collision.disabled = false

	process_mode = Node.PROCESS_MODE_INHERIT


func stop() -> void:
	_audio_player.stop()


func start() -> void:
	_audio_player.play()
