class_name Bullet
extends CharacterBody3D

@export var gun : Gun

enum State { FIRED, IDLE }
@export var state : State = State.IDLE

@export_category("Bullet parameters")
@export var speed : float = 1.0 # meter per sec
@export var mass : float = 0.1 # kg

const g = 9.8 # meter per sec^2

func _physics_process(delta):
	if state == State.FIRED and not is_on_floor():
		velocity.y -= mass * g * delta
		var collision_info = move_and_collide(velocity * delta)
		if collision_info: # TODO applying damage
			state = State.IDLE
			gun.collect(self)

func set_player_collision_preset():
	collision_layer = 0b100
	collision_mask = 0b011

func set_enemy_collision_preset():
	collision_layer = 0b010
	collision_mask = 0b111
