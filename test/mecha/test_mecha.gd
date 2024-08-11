extends CharacterBody3D

@export var movement_speed : float = 5.0 # m/s
@export var mass = 1000.0 # kg
var g = 9.8 # m/s^2

func _ready():
	$Cabin/LeftGun.gun_user = self
	$Cabin/RightGun.gun_user = self

func _process(delta):
	if Input.is_action_pressed("gun1") or Input.is_action_just_pressed("gun1"):
		$Cabin/LeftGun.fire()
	if Input.is_action_pressed("gun2") or Input.is_action_just_pressed("gun2"):
		$Cabin/RightGun.fire()

func _physics_process(delta):
	var move = Input.get_vector("move_backward", "move_forward", "move_left", "move_right")
	move *= movement_speed
	velocity = Vector3(-move.y, - mass * g * delta, move.x)
	move_and_slide()
