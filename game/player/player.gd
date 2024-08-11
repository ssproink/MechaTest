class_name Player
extends Character

@export_category("Maneuvering parameters")
@export_range(0.0, 1e6, 0.1, "suffix:m/s^2") var jump_acceleration : float = g + 1
@export_range(0.0, 1e6, 0.1, "suffix:m/s^2") var jetpack_acceleration : float = g + 1

@export_category("Jetpack fuel parameters")
# Fuel point = fuel for one second of flight
@export_range(0.0, 1e6, 0.1, "suffix:fp") var fuel : float = 10.0
@export_range(0.0, 1e6, 0.1, "suffix:fp") var fuel_max : float = 10.0
@export_range(0.0, 1e6, 0.1, "suffix:fp/s") var fuel_regen : float = 1.0

func _physics_process(delta):
	if not is_equal_approx(fuel, fuel_max):
		fuel = clamp(fuel + fuel_regen * delta, 0.0, fuel_max)
	var move_vector = Vector3.ZERO
	var fly_vector = Vector3.ZERO
	var move_2d = Input.get_vector("move_backward", "move_forward", "move_left", "move_right")
	if is_on_floor():
		var on_foot = move_2d
		on_foot *= speed
		move_vector.x = -on_foot.y
		move_vector.z = on_foot.x
		if Input.is_action_just_pressed("jump"):
			move_vector.y += mass * jump_acceleration * delta
	if (Input.is_action_just_pressed("fly") or Input.is_action_pressed("fly")) \
	and fuel >= delta:
		var on_fly = move_2d
		fly_vector = Vector3.UP
		fly_vector.x = -on_fly.y
		fly_vector.z = on_fly.x
		fly_vector = fly_vector.normalized() * mass * jetpack_acceleration * delta
		fuel -= delta
	velocity += move_vector + fly_vector
	move_and_slide()
