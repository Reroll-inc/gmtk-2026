extends Resource
class_name PlayerData

@export_category("Mechanics")
@export_group("Climb")
@export var climb_speed: float = 200.0
@export var climb_step_interval: float = 0.25

@export_group("Dash")
@export var dash_speed: float = 400.0
@export var dash_duration: float = 0.18
@export var dash_cooldown: float = 0.4

@export_group("Double Jump")
@export var double_jump_max: int = 1

@export_group("Fly")
@export var fly_speed: float = 200.0
@export var fly_flap_interval: float = 1.0

@export_group("Movement")
@export var movement_step_interval: float = 0.3
