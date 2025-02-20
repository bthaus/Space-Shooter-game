extends Enemy
class_name FollowEnemy

var current_direction=Vector2.DOWN
var angle
func _process(delta: float) -> void:
	
	if not player or not active: return
	
	var direction=(player.global_position-global_position).normalized()
	var movement_direction=lerp(current_direction,direction,delta*1)
	angle=get_angle_to(player.global_position)+deg_to_rad(90)
	$MultiViewPort/rot.rotation=lerp_angle($MultiViewPort/rot.rotation,angle,delta*4)
	reference_quat=no_rotation_basis.rotated(Vector3(0,1,0).normalized(),-angle)
	current_direction=movement_direction
	move(movement_direction,delta)
	move(Vector2.ZERO,delta)
	move(Vector2.ZERO,delta)
	
	pass
	
func attack(p:Projectile):
	if player:
		p.shoot(Vector2.from_angle(angle-deg_to_rad(90))*3)
	pass;	


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is GameObject:
		area.get_parent().hit()
	die()
	pass # Replace with function body.
