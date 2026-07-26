extends CharacterBody2D
class_name Player

@export var jump_height: float = -450.0
@export var gravity: float = 20.5
@export var jump_hold: float = 0.5
@export var fast_fall_gravity: float = 600.0

@export var max_speed: float = 400.0
@export var acceleration: float = 52.5
@export var friction: float = 12.5

@export var air_acceleration: float = 10.0
@export var bounce_up_on_kill: float = -300.0
@export var max_hp: int = 3

@onready var mechanics: Node = $Mechanics
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_listener: AudioListener2D = $AudioListener2D
@onready var camera: Camera2D = $Camera2D

@export var dmg_sound: AudioStream = preload("res://assets/sfx/powerdown07.mp3")
@export var fail_sound: AudioStream = preload("res://assets/sfx/division_of_ninja.mp3")
@export var kill_enemy_sound: AudioStream = preload("res://assets/sfx/poyo.mp3")

var _mechanics: Array[Mechanic] = []
var _active: Mechanic = null

var last_facing: Vector2 = Vector2.RIGHT
var _kill_enabled: bool = true

var hp: int = max_hp


func _ready() -> void:
	audio_listener.make_current()
	SignalBus.remove_mechanic.connect(remove_mechanic)
	SignalBus.player_got_spike.connect(_handle_dmg)
	SignalBus.game_failed.connect(_handle_exit)
	SignalBus.level_completed.connect(_handle_exit)
	SignalBus.game_start.connect(_handle_start)
	SignalBus.to_next_level.connect(_handle_start)

	for child: Node in mechanics.get_children():
		if child is Mechanic:
			var m: Mechanic = child

			m.setup(self)
			_mechanics.append(m)

	_switch_mechanic(_fallback())


func _exit_tree() -> void:
	SignalBus.remove_mechanic.disconnect(remove_mechanic)
	SignalBus.player_got_spike.disconnect(_handle_dmg)
	SignalBus.game_failed.disconnect(_handle_exit)
	SignalBus.level_completed.disconnect(_handle_exit)
	SignalBus.game_start.disconnect(_handle_start)
	SignalBus.to_next_level.disconnect(_handle_start)


func _fallback() -> Mechanic:
	for m: Mechanic in _mechanics:
		if m.can_activate():
			return m
	return null


func _switch_mechanic(next: Mechanic) -> void:
	if next == _active:
		return

	if _active != null:
		_active.on_exit()
	_active = next

	if _active != null:
		_active.on_enter()


func _physics_process(delta: float) -> void:
	var dir: Vector2 = read_input_direction()

	last_facing = dir if dir != Vector2.ZERO else last_facing

	if _active == null:
		_switch_mechanic(_fallback())

	# no mechanic is active, try to switch to one that can be activated
	# or... maybe the current mechanic allows a break?
	if _active == null or _active.is_interruptible():
		for m: Mechanic in _mechanics:
			if m == _active:
				continue
			if m.can_activate() and (_active == null or _active.is_interruptible_by(m)):
				_switch_mechanic(m)
				break

	# run mechanic update loop
	if _active != null:
		# if the active mechanic returns false, it means its over
		if not _active.on_physics_process(delta):
			_switch_mechanic(_fallback())

	move_and_slide()


func _handle_dmg() -> void:
	hp -= 1

	if hp == 0:
		_play_fail_sound()
		SignalBus.game_failed.emit()
	else:
		_play_dmg_sound()
		SignalBus.player_receive_dmg.emit()


func _play_dmg_sound() -> void:
	if audio_player.playing:
		audio_player.stop()
	audio_player.stream = dmg_sound
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()


func _play_fail_sound() -> void:
	if audio_player.playing:
		audio_player.stop()
	audio_player.stream = fail_sound
	audio_player.pitch_scale = 1.0
	audio_player.play()


func _handle_exit() -> void:
	camera.enabled = false


func _handle_start() -> void:
	hp = max_hp
	camera.enabled = true


func remove_mechanic(type: Mechanic.Type) -> void:
	if type == Mechanic.Type.KILL:
		_kill_enabled = false

		print("Removing mechanic: Kill")
		return

	var mechanic_name: String = Mechanic.NODE_NAME[type]
	var m: Mechanic = mechanics.get_node_or_null(mechanic_name)

	if m == null:
		print("Mechanic not found: " + mechanic_name)
		return

	print("Removing mechanic: " + mechanic_name)

	if m == _active:
		_switch_mechanic(_fallback())

	_mechanics.erase(m)
	m.queue_free()


func read_input_direction() -> Vector2:
	var hor: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var ver: float = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	return Vector2(hor, ver).normalized()


func is_falling() -> bool:
	return velocity.y > 0


func on_enemy_hit(enemy: Node2D, type: Enemy.Type) -> void:
	if _kill_enabled and is_falling():
		velocity.y = bounce_up_on_kill

		SignalBus.enemy_killed.emit(type)

		_play_kill_sound()

		enemy.call_deferred("kill")
	else:
		_handle_dmg()


func _play_kill_sound() -> void:
	if audio_player.playing:
		audio_player.stop()
	audio_player.stream = kill_enemy_sound
	audio_player.pitch_scale = randf_range(0.9, 1.1)
	audio_player.play()


func reset(start: Node2D) -> void:
	position = start.position
