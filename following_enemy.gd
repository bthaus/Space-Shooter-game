extends Enemy
class_name FollowEnemy

var current_direction=Vector2.DOWN
var angle
var immortal=false
var push_angle=0
func hit():
	if immortal:return false
	return super()
func _ready() -> void:
	super()
	get_tree().create_timer(1.5).timeout.connect(func():
		immortal=false)
func _process(delta: float) -> void:

		
	if not player or not active: return
	
	var direction=(player.global_position-global_position).normalized()
	if immortal:
		direction=Vector2.from_angle(push_angle)
		
	var movement_direction=lerp(current_direction,direction,delta*1)
	angle=get_angle_to(player.global_position)+deg_to_rad(90)
	if immortal:
		angle=push_angle
	$MultiViewPort/rot.rotation=lerp_angle($MultiViewPort/rot.rotation,angle,delta*4)
	reference_quat=no_rotation_basis.rotated(Vector3(0,1,0).normalized(),-angle)
	current_direction=movement_direction
	move(movement_direction,delta)
	move(Vector2.ZERO,delta)
	super(delta)
	
	pass

	
func attack(p:Projectile):
	if player:
		p.shoot(Vector2.from_angle(angle-deg_to_rad(90))*3)
	pass;	


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is Mothership:return
	if area.get_parent() is GameObject:
		area.get_parent().hit()
	if immortal:return	
	die()
	pass # Replace with function body.
