extends Enemy


func attack(p:Projectile):
	var p1=p.duplicate()
	var p2=p.duplicate()
	p1.shooter=p.shooter
	p2.shooter=p.shooter
	add_sibling(p1)
	add_sibling(p2)
	p.shoot(Vector2.DOWN)
	p1.shoot(Vector2.DOWN.rotated(25))
	p2.shoot(Vector2.DOWN.rotated(-25))
	pass;
