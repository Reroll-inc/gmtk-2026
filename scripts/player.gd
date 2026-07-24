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

@onready var mechanics: Node = $Mechanics

var _mechanics: Array[Mechanic] = []
var _active: Mechanic = null

var last_facing: Vector2 = Vector2.RIGHT


func _ready() -> void:
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


func read_input_direction() -> Vector2:
	var hor: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var ver: float = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	return Vector2(hor, ver).normalized()


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
