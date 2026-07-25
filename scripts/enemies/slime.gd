extends CharacterBody2D
class_name Slime

@export var speed: float = 50.0

@onready var _left_floor_check: RayCast2D = $LeftFloorCheck
@onready var _right_floor_check: RayCast2D = $RightFloorCheck
@onready var _sprite: AnimatedSprite2D = $Sprite
@onready var _collision: CollisionShape2D = $CollisionShape2D
@onready var _hitbox_collision: CollisionShape2D = $Hitbox/CollisionShape2D

var direction: int = 1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	velocity.x = direction * speed

	move_and_slide()

	if (
		is_on_wall()
		or is_on_floor()
		and (
			direction == 1 and not _right_floor_check.is_colliding()
			or direction == -1 and not _left_floor_check.is_colliding()
		)
	):
		_flip_direction()


func _flip_direction() -> void:
	direction *= -1
	_sprite.flip_h = !_sprite.flip_h


# This code should always expect the enemy to collide against the player.
# Nothing else is going to hit it as part of the hitbox, so it is safe.
func _on_hitbox_body_entered(player: Player) -> void:
	player.on_enemy_hit(self)


func kill() -> void:
	hide()

	_collision.disabled = true
	_hitbox_collision.disabled = true

	process_mode = Node.PROCESS_MODE_DISABLED


func restore() -> void:
	show()

	_collision.disabled = false
	_hitbox_collision.disabled = false

	process_mode = Node.PROCESS_MODE_ALWAYS
