extends Node3D

func _process(delta):
	if Input.is_action_pressed("gun1") or Input.is_action_just_pressed("gun1"):
		$TestGunUser/TestGun.fire()
	$CanvasLayer/Params/FPS.text = "%.1f" % Engine.get_frames_per_second()
	$CanvasLayer/Params/Magazine.text = "Mag: %d/%d" % [
		$TestGunUser/TestGun.bullets_in_mag,
		$TestGunUser/TestGun.bullets
	]
	$CanvasLayer/Params/GunStatus.text = Gun.State.keys()[$TestGunUser/TestGun.state]
	$CanvasLayer/Params/BulletPool.text = "bullet_pool: %d" % \
		$TestGunUser/TestGun.get_bullet_pool_size()
