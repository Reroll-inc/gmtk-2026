extends CanvasLayer
class_name Hud

@export var max_hp: int = 3

@onready var hp: HBoxContainer = $HP

var _current_hp: int = 3
var hp_1_texture: AtlasTexture = preload("res://sprites/hp_1.tres")
var hp_0_texture: AtlasTexture = preload("res://sprites/hp_0.tres")


func _init() -> void:
	SignalBus.player_receive_dmg.connect(_on_player_dmg)
	SignalBus.to_next_level.connect(_on_reset)
	SignalBus.game_failed.connect(_on_reset)


func _ready() -> void:
	_redraw_hp()


func _exit_tree() -> void:
	SignalBus.player_receive_dmg.disconnect(_on_player_dmg)
	SignalBus.to_next_level.disconnect(_on_reset)
	SignalBus.game_failed.disconnect(_on_reset)


func _on_player_dmg() -> void:
	_current_hp -= 1
	_redraw_hp()


func _on_reset() -> void:
	_current_hp = max_hp
	_redraw_hp()


func _redraw_hp() -> void:
	var children: Array[Node] = hp.get_children()

	for i in children.size():
		var texture: TextureRect = children[i]

		texture.texture = hp_1_texture if i < _current_hp else hp_0_texture
