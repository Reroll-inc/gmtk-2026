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

@onready var mechanics: Node = $Mechanics

var _mechanics: Array[Mechanic] = []
var _active: Mechanic = null

var last_facing: Vector2 = Vector2.RIGHT
var _kill_enabled: bool = true


func _ready() -> void:
	SignalBus.remove_mechanic.connect(remove_mechanic)

	for child: Node in mechanics.get_children():
		if child is Mechanic:
			var m: Mechanic = child

			m.setup(self)
			_mechanics.append(m)

	_switch_mechanic(_fallback())


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


func on_enemy_hit(enemy: Node2D) -> void:
	if _kill_enabled and is_falling():
		velocity.y = bounce_up_on_kill

		SignalBus.enemy_killed.emit()

		enemy.call_deferred("kill")
	else:
		SignalBus.player_receive_dmg.emit()


func reset(start: Node2D) -> void:
	position = start.position
