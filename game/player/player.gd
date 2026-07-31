extends CharacterBody2D
class_name Player

enum Position {
	START,
	CREDITS,
}

const PROPERTIES: PlayerData = preload("res://game/player/player_data.tres")

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

@export var dmg_sound: AudioStream = preload("res://assets/sfx/powerdown07.mp3")
@export var fail_sound: AudioStream = preload("res://assets/sfx/division_of_ninja.mp3")
@export var kill_enemy_sound: AudioStream = preload("res://assets/sfx/poyo.mp3")

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_listener: AudioListener2D = $AudioListener2D
@onready var camera: Camera2D = $Camera2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var _camera_limit: Vector2i = Vector2i(camera.limit_right, camera.limit_bottom)

var last_facing: Vector2 = Vector2.RIGHT

var _mechanics: Dictionary[Mechanic.Type, Mechanic] = { }
var _active: Mechanic = null
var _initial_skills: Array = Mechanic.Type.values()
var _kill_enabled: bool = true
var _credits_limit: Dictionary[String, Vector2i] = {
	top = Vector2i(0, 31 * 16),
	bottom = Vector2i(30 * 16, 48 * 16),
}
var _hp: int = max_hp


func _ready() -> void:
	set_anim("idle")
	audio_listener.make_current()
	SignalBus.remove_mechanic.connect(remove_mechanic)
	SignalBus.player_got_spike.connect(_handle_dmg)
	SignalBus.game_failed.connect(pause)
	SignalBus.level_completed.connect(pause)
	SignalBus.game_start.connect(_handle_start)
	SignalBus.to_next_level.connect(_handle_next_level)

	for type: Mechanic.Type in _initial_skills:
		match type:
			Mechanic.Type.CLIMB:
				_mechanics.set(type, Climb.new(self))
			Mechanic.Type.DASH:
				_mechanics.set(type, Dash.new(self))
			Mechanic.Type.DOUBLE_JUMP:
				_mechanics.set(type, DoubleJump.new(self))
			Mechanic.Type.FLY:
				_mechanics.set(type, Fly.new(self))
			Mechanic.Type.MOVEMENT:
				_mechanics.set(type, BaseMovement.new(self))

	_switch_mechanic(_fallback())


func set_anim(anim_name: String, facing: Vector2 = Vector2.ZERO) -> void:
	if anim.animation != anim_name:
		anim.play(anim_name)
	anim.flip_h = last_facing.x < 0.0 if facing == Vector2.ZERO else facing.x < 0.0


func _fallback() -> Mechanic:
	for m: Mechanic in _mechanics.values():
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
		for m: Mechanic in _mechanics.values():
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
	_hp -= 1

	if _hp == 0:
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


func pause() -> void:
	pass


func unpause() -> void:
	pass


func _handle_start() -> void:
	_hp = max_hp

	_reset_mechanics()


func _handle_next_level() -> void:
	_hp = max_hp


func _reset_mechanics() -> void:
	for m: Mechanic in _mechanics.values():
		m.enable()


func remove_mechanic(type: Mechanic.Type) -> void:
	if type == Mechanic.Type.KILL:
		_kill_enabled = false

		print("Removing mechanic: Kill")
		return

	var mechanic_name: String = Mechanic.NODE_NAME[type]
	var m: Mechanic = _mechanics.get(type)

	if m == null:
		print("Mechanic not found: " + mechanic_name)
		return

	print("Removing mechanic: " + mechanic_name)

	if m == _active:
		_switch_mechanic(_fallback())

	m.disable()


func read_input_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_back").normalized()


func is_falling() -> bool:
	return velocity.y > 0


func on_enemy_hit(enemy: Node2D, type: Enemy.Type) -> void:
	if Input.is_action_pressed("fly"):
		SignalBus.enemy_killed.emit(type)
		_play_kill_sound()
		enemy.call_deferred("kill")
		return

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


func reset(type: Position, marker: Marker2D) -> void:
	position = marker.position
	velocity = Vector2.ZERO

	if type == Position.CREDITS:
		camera.limit_left = _credits_limit.top.x
		camera.limit_top = _credits_limit.top.y
		camera.limit_right = _credits_limit.bottom.x
		camera.limit_bottom = _credits_limit.bottom.y
	else:
		camera.limit_left = 0
		camera.limit_top = 0
		camera.limit_right = _camera_limit.x
		camera.limit_bottom = _camera_limit.y
