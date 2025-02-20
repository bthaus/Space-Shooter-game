extends GameObject
class_name Projectile
@export var hitbox:Area2D
var direction
@export var speed=1000

var shooter
func shoot(direction):
	hitbox.monitorable=true
	hitbox.monitoring=true
	self.direction=direction
	
func _process(delta: float) -> void:
	if not active: return
	if direction:
		translate(direction*speed*delta)	
func hit():
	remove_on_hit()

func _on_hitbox_area_entered(area: Area2D) -> void:
	var parent=area.get_parent()
	if parent is Projectile and parent.shooter==shooter or parent == shooter:
		return
	if parent is GameObject:
		active=false
		var dead=parent.hit()
		hitbox.queue_free()
		if self is PlayerProjectile:
			shooter.add_hit()
		remove_on_hit()
	pass # Replace with function body.
func remove_on_hit():
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	remove_on_hit()
	pass # Replace with function body.
