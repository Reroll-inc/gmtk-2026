class_name Player
extends CharacterBody2D

@onready var mechanics: Node = $Mechanics

var _mechanics: Array[Mechanic] = []
var _active: Mechanic = null

func _ready() -> void:
	for child in mechanics.get_children():
		if child is Mechanic:
			var m: Mechanic = child
			m.setup(self)
			_mechanics.append(m)
	_switch_mechanic(_fallback())

func _fallback() -> Mechanic:
	for m in _mechanics:
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

# tendria que poder armar una especie de state machine, levantando los nodos de mechanics que tenga disponibles
func _physics_process(delta: float) -> void:
	#como paso de base a climb?
	#de climb a dash?
	#de dash a base?
	if _active == null:
		_switch_mechanic(_fallback())
	
	if Input.is_action_just_pressed("dash"):
		print("dash pressed")

	# no mechanic is active, try to switch to one that can be activated
	# or... maybe the current mechanic allows a break?
	if _active == null or _active.can_interrupt():
		for m in _mechanics:
			if m == _active:
				print("active mechanic is null, but we are trying to switch to it")
				continue
			if m.can_activate():
				print("switching to mechanic: ", m)
				_switch_mechanic(m)
				break
	
	# run mechanic update loop
	if _active != null:
		# if the active mechanic returns false, it means its over
		if not _active.on_physics_process(delta):
			_switch_mechanic(_fallback())
	
	move_and_slide()
