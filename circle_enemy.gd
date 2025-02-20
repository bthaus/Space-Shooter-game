extends Enemy

func _process(delta: float) -> void:
	if  active:
		translate(Vector2.DOWN/9*speed*50*delta)
	$SpaceShip/origin/Spaceship.rotate(Vector3(0,1,0).normalized(),delta*0.7)
	$MultiViewPort/rot.rotate(delta)
func attack(p:Projectile):
	var angles=[$'MultiViewPort/rot/1',$'MultiViewPort/rot/2',$'MultiViewPort/rot/3',$'MultiViewPort/rot/4',$'MultiViewPort/rot/5',$'MultiViewPort/rot/6']
	for a in angles:
		var p1=p.duplicate()
		p1.shooter=p.shooter
		add_sibling(p1)
		p1.shoot((a.global_position-$MultiViewPort/rot/Shootpoint.global_position).normalized())
		
	p.queue_free()
	pass;
