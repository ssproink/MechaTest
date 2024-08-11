class_name Character
extends CharacterBody3D

@export_category("Physical parameters")
@export_range(0.0, 1e6, 0.1, "suffix:m/s") var speed : float
@export_range(0.0, 1e6, 0.001, "suffix:kg") var mass : float

@export_category("Health parameters")
@export var alive : bool = true
@export_range(1, 1e6, 1, "suffix:hp") var hp : int :
	set(health):
		if not alive:
			return
		#hp = clamp(health, 0, 1e6)
		if hp == 0:
			alive = false
@export_range(1, 1e6, 1, "suffix:hp") var hp_max : int :
	set(health_max):
		hp_max = health_max
		hp = clamp(hp, 0, hp_max)
@export_range(1, 1e6, 1, "suffix:hp/s") var hp_regen : int

const g = 9.8

func gravity(delta) -> Vector3:
	return Vector3(0, - mass * g * delta, 0)

func _physics_process(delta):
	velocity = gravity(delta)
	move_and_slide()

func _process(delta):
	if alive and not is_equal_approx(hp, hp_max):
		hp += hp_regen * delta
