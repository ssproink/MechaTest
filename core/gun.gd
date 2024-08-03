class_name Gun
extends Node3D

signal Reloading
signal Reloaded

enum State { READY, RELOADING }
var state : State = State.READY :
	set(st):
		state = st
		if state == State.RELOADING:
			Reloading.emit()
		elif state == State.READY:
			Reloaded.emit()

@export var gun_user : Node3D = null

@export_category("Magazine")
@export var bullets_in_mag : int = 1 :
	set(count):
		bullets_in_mag = count
		if count <= 0 and bullets > 0:
			$Reload.start()
			state = State.RELOADING
@export var mag_capacity : int = 1
@export var bullets : int = 1

@export_category("Fire")
@export var fire_rate : float = 1.0 # sec
@export var spread : float = 0.0 # meter of radius per meter
@export var reload_time : float = 1.0 : # sec
	set(time):
		reload_time = time
		$Reload.wait_time = reload_time
@export var reload_time_left : float : # sec
	get:
		return $Reload.time_left
@export var trace_begin : Vector3 = Vector3.ZERO
@export var trace_direction : Transform3D = Transform3D.IDENTITY

var bullet_pool : Array[Bullet] = [ ]

func collect(bullet : Bullet):
	bullet_pool.append(bullet)
	prepare_bullet(bullet)

func prepare_bullet(bullet : Bullet):
	bullet.global_position = global_position
	add_child(bullet)
	bullet.position = trace_begin
	bullet.transform = trace_direction

func make_bullet() -> Bullet:
	assert(false, "Gun#make_bullet must be overrided.")
	return null

func _on_reload_timeout():
	if bullets >= mag_capacity:
		bullets_in_mag = mag_capacity
		bullets -= mag_capacity
	else:
		bullets_in_mag = bullets
		bullets = 0
	state = State.READY

func fire():
	var bullet : Bullet
	if not bullet_pool.is_empty():
		bullet = bullet_pool.pop_back()
	else:
		bullet = make_bullet()
		bullet.gun = self
		prepare_bullet(bullet)
	bullet.reparent(gun_user.get_parent_node_3d())
	bullet.velocity = global_transform.basis * Vector3.FORWARD * bullet.speed
	bullet.state = Bullet.State.FIRED
