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
@export var mag_capacity : int
@export var bullets_in_mag : int :
	set(count):
		bullets_in_mag = clamp(count, 0, mag_capacity)
		if count <= 0 and bullets > 0 and $Reload.is_stopped():
			$Reload.start()
			state = State.RELOADING
@export var bullets : int

@export_category("Fire")
@export_range(1, 60000, 1, "suffix:rpm") var fire_rate : int = 1000 : # rpm
	set(rate):
		fire_rate = rate
		calc_fire_delay()
@export_range(0.0, 10.0, 0.01, "suffix:m") var spread : float = 0.0 # meter of radius
@export_range(0.0, 1e6, 0.1, "suffix:s") var reload_time : float = 1.0 : # s
	set(time):
		reload_time = time
		$Reload.wait_time = reload_time
@export_range(0.0, 1e6, 0.1, "suffix:s") var reload_time_left : float : # s
	get:
		return $Reload.time_left
@export var trace_begin : Vector3 = Vector3.ZERO
@export var trace_direction : Transform3D = Transform3D.IDENTITY

var bullet_pool : Array[Bullet] = [ ]
var last_shot_time : int = Time.get_ticks_msec()
var fire_delay : int = 0 #ms

func _init():
	calc_fire_delay()

func calc_fire_delay():
	fire_delay = 60000 / fire_rate

func collect(bullet : Bullet):
	bullet_pool.append(bullet)
	prepare_bullet(bullet)

func prepare_bullet(bullet : Bullet):
	if bullet.get_parent() == null:
		add_child(bullet)
	else:
		bullet.global_position = global_position
		bullet.reparent(self)
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
	var current_time = Time.get_ticks_msec()
	if current_time - last_shot_time >= fire_delay and state == State.READY:
		last_shot_time = current_time
	else:
		return
	var bullet : Bullet
	if not bullet_pool.is_empty():
		bullet = bullet_pool.pop_back()
	else:
		bullet = make_bullet()
		bullet.gun = self
		prepare_bullet(bullet)
	bullet.reparent(gun_user.get_parent_node_3d())
	bullet.velocity = global_transform.basis * Vector3(0, 0, 1) * bullet.speed
	bullet.state = Bullet.State.FIRED
	bullets_in_mag -= 1

func get_bullet_pool_size():
	return bullet_pool.size()
