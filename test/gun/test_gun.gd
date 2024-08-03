extends Gun

const TestBullet = preload("res://test/gun/test_bullet.tscn")

func make_bullet() -> Bullet:
	return TestBullet.instantiate()
