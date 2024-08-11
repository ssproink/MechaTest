class_name Bullet
extends CharacterBody3D

const g = 9.8 # meter per sec^2

@export var gun : Gun

enum State { FIRED, IDLE }
@export var state : State = State.IDLE

@export_category("Bullet parameters")
@export_range(0.0, 1e6, 0.1, "suffix:m/s") var speed : float = 1.0
@export_range(0, 1e6, 1, "suffix:gr") var mass : int = 100
@export_range(0, 1e6, 0.1, "suffix:m") var max_distance : float = 100.0

var first_position : Vector3
var first_iter : bool = true

func _physics_process(delta):
	if state == State.FIRED and not is_on_floor():
		velocity.y -= mass / 1000.0 * g * delta
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			collect()
		if first_iter:
			first_position = position
			first_iter = false
		else:
			if first_position.distance_to(position) > max_distance:
				collect()

func _init():
	collision_layer = 0b000
	collision_mask = 0b111

func collect():
	state = State.IDLE
	gun.collect(self)
	first_iter = true
