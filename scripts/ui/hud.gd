extends Node
class_name Hud

@export var max_hp: int = 3

@onready var hp: HBoxContainer = $HP
@onready var _score: Label = $Score
@onready var _progress: Array[Node] = $LevelProgress.get_children()

var _current_hp: int = 3
var hp_1_texture: CompressedTexture2D = preload("res://sprites/hp_1.tres")
var hp_0_texture: CompressedTexture2D = preload("res://sprites/hp_0.tres")


func _init() -> void:
	SignalBus.player_receive_dmg.connect(_on_player_dmg)
	SignalBus.to_next_level.connect(_on_reset)
	SignalBus.game_failed.connect(_on_reset)
	SignalBus.score_update.connect(_on_score_update)
	SignalBus.remove_mechanic.connect(_handle_remove_mechanic)
	SignalBus.game_start.connect(_clear_state)


func _ready() -> void:
	_redraw_hp()


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


func _on_score_update(value: int) -> void:
	_score.text = var_to_str(value)


func _handle_remove_mechanic(type: Mechanic.Type) -> void:
	for mechanic: HudIcon in _progress:
		if mechanic.type == type:
			mechanic.call_deferred("complete")
			break


func _clear_state() -> void:
	_score.text = "0"

	for mechanic: HudIcon in _progress:
		mechanic.clear()
