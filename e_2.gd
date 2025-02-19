extends Spaceship
class_name Enemy
@export var difficulty=1
@export var shoot_frequency:float

func _ready() -> void:
	$Shoot_timer.wait_time=shoot_frequency
	super()
func _process(delta: float) -> void:

	move(Vector2.DOWN/3,delta)
		
func get_projectile():
	if not projectile:
		projectile=load('res://e1p.tscn')
	return projectile.instantiate()	
func _on_shoot_timer_timeout() -> void:
	if not active: return
	var b=get_projectile()
	b.show()
	b.shooter=self
	b.global_position=$MultiViewPort/rot/Shootpoint.global_position
	add_sibling(b)
	attack(b)
	pass # Replace with function body.
func attack(projectile:Projectile):
	projectile.shoot(Vector2.DOWN)
	pass;

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	
	queue_free()
	pass # Replace with function body.
