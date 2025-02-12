extends Spaceship
class_name Enemy
@export var difficulty=1
func _process(delta: float) -> void:
	move(Vector2.DOWN/3,delta)
func get_projectile():
	if not projectile:
		projectile=load('res://e1p.tscn')
	return projectile.instantiate()	
func _on_shoot_timer_timeout() -> void:
	var b=get_projectile()
	b.show()
	b.global_position=$Shootpoint.global_position
	add_sibling(b)
	b.shoot(Vector2.DOWN)
	pass # Replace with function body.
