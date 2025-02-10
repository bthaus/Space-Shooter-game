extends AnimatedSprite2D
class_name Projectile

var direction
@export var speed=1000
func shoot(direction):
	$projectile_hitbox.monitorable=true
	$projectile_hitbox.monitoring=true
	self.direction=direction
func _process(delta: float) -> void:
	if direction:
		translate(direction*speed*delta)	


func _on_projectile_hitbox_area_entered(area: Area2D) -> void:
	play(&'splash')
	$projectile_hitbox.queue_free()
	pass # Replace with function body.


func _on_animation_finished() -> void:
	queue_free()
	pass # Replace with function body.
