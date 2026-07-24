extends RigidBody2D
class_name Enemy

@onready var _sprite: AnimatedSprite2D = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_sprite.play("walk")


func _on_hitbox_body_entered(_body: Node2D) -> void:
	SignalBus.enemy_hit.emit(self)
