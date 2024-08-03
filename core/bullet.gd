class_name Bullet
extends CharacterBody3D

@export var gun : Gun

enum State { FIRED, IDLE }
@export var state : State = State.IDLE

@export_category("Bullet parameters")
@export_range(0.0, 1e6, 0.1, "suffix:m/s") var speed : float = 1.0 # m/s
@export_range(0, 1e6, 1, "suffix:gr") var mass : int = 100 # gr

const g = 9.8 # meter per sec^2

func _physics_process(delta):
	if state == State.FIRED and not is_on_floor():
		velocity.y -= mass / 1000.0 * g * delta
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			#var target = collision_info.get_collider()
			#if not (target is Bullet and target.gun == gun):
				# TODO applying damage
			state = State.IDLE
			gun.collect(self)

func _init():
	collision_layer = 0b000
	collision_mask = 0b111

#func set_player_collision_preset():
	#collision_mask = 0b101
#
#func set_enemy_collision_preset():
	#collision_mask = 0b111
