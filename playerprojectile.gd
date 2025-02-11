extends Projectile
class_name PlayerProjectile



func _on_animation_finished() -> void:
	queue_free()
	pass # Replace with function body.
	
func remove_on_hit():
	$projectile_plasma.play(&'splash')
	get_tree().create_timer(1).timeout.connect(queue_free)
	pass
