extends Node2D
class_name Ghost

@export var speed: float = 50.0

@onready var _sprite: AnimatedSprite2D = $Sprite

var direction: int = 1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


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
