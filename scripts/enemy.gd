extends CharacterBody2D
class_name Enemy

@export var speed: float = 50.0

@onready var _left_floor_check: RayCast2D = $LeftFloorCheck
@onready var _right_floor_check: RayCast2D = $RightFloorCheck
@onready var _sprite: AnimatedSprite2D = $Sprite

var direction: int = 1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	_sprite.play("walk")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	velocity.x = direction * speed

	move_and_slide()

	if (
		is_on_floor()
		and (
			direction == 1 and not _right_floor_check.is_colliding()
			or direction == -1 and not _left_floor_check.is_colliding()
		)
	):
		flip_direction()


func flip_direction() -> void:
	direction *= -1
	_sprite.flip_h = !_sprite.flip_h


# This code should always expect the enemy to collide against the player.
# Nothing else is going to hit it as part of the hitbox, so it is safe.
func _on_hitbox_body_entered(player: Player) -> void:
	if player.is_falling():
		player.bounce_up_on_hit_enemy()
		SignalBus.enemy_killed.emit()

		queue_free()
	else:
		SignalBus.player_receive_dmg.emit()
