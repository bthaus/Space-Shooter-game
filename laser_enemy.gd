extends Enemy
class_name LaserEnemy


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_laser(active,delta)
	super(delta)
	pass
func _on_shoot_timer_timeout() -> void:
	pass;	
