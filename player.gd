extends Spaceship
class_name PlayerShip
var ship_rotation=Vector2.ZERO

@export var movement_rect:Polygon2D
signal player_died
signal player_hit
func hit():
	player_hit.emit()
	super()
	pass;
func die():
	if not active:return
	active=false
	player_died.emit()
	super()
	pass;	
func _ready() -> void:
	super()

var angle=0.0	
var new_direction=Vector2.ZERO

func handle_laser(delta):
	if Input.is_action_pressed(&'laser'):
		if not fly_buff:
			new_direction=Vector2.ZERO
			twirling=Vector2.ZERO
		laser_power+=delta/1.5
		accum=clamp(accum+delta,0,0.4)
		
		laser_power=clamp(laser_power,0,1)
		var targets=$MultiViewPort/rot/Raycast.get_overlapping_areas()
		if accum >0.3 and laser_power==1:
			accum=0
			for target in targets:
				
				if target.get_parent() == self:continue
				if target  and target.get_parent() is GameObject:
					target.get_parent().hit()
				
		$MultiViewPort/rot/laser.show()
		$MultiViewPort/rot/laser.material.set_shader_parameter("progress",laser_power)
		$MultiViewPort/rot/laser.scale.x=lerp(0,24,laser_power*2)
	else:
		lower_laser(delta)
func _process(delta: float) -> void:
	super(delta)
	if not active:return
	
	
	
	if not Input.is_action_pressed(&'laser') or fly_buff:
		new_direction.x=Input.get_axis(&"ui_left",&"ui_right")
		new_direction.y=Input.get_axis(&"ui_up",&"ui_down")
		ship_rotation.x=Input.get_joy_axis(0,JOY_AXIS_RIGHT_X)
		ship_rotation.y=Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y)
	
	if ship_rotation.length() >0.3:
		angle=ship_rotation.normalized().angle()+deg_to_rad(45)
	if Input.is_action_just_pressed(&"reset_rot"):
		angle=0	
	directions.clear()
	if both_triggers_pressed():
		lower_laser(delta)
		new_direction*=1.1
	direction=lerp(direction,new_direction.rotated(angle),delta*2)
	directions.append(Vector2(0,-1).rotated(angle))	
	$MultiViewPort/rot.rotation=lerp_angle($MultiViewPort/rot.rotation,angle,delta*4)
	#direction=lerp(direction,target_rot,delta)
	var move=direction
	var length=direction.length()
	if length<0.3:
		move=Vector2.ZERO
	$MultiViewPort/rot/PArticles.toggle(move!=Vector2.ZERO or twirling!=Vector2.ZERO)
	$MultiViewPort/rot/PArticles.set_ratio(length)
	if twirling:
		$MultiViewPort/rot/PArticles.set_ratio(1)
	var d=Input.get_axis(&"left_button",&"right_button")
	if d!=0 and twirling==Vector2.ZERO:
		get_tree().create_timer(0.2).timeout.connect(end_twirl)
		twirling+=Vector2(d*4,0).rotated(angle)
		$MultiViewPort/rot/particles_boost.toggle(true)
	if not both_triggers_pressed():
		handle_shoot()
		handle_laser(delta)
	
	move(twirling,delta)
	move(direction,delta)	
	reference_quat=no_rotation_basis.rotated(Vector3(0,1,0).normalized(),-angle)
	#$SpaceShip/origin/Spaceship.rotation.y=-angle
	
	clamp_position()
	
func clamp_position():
	var pos=clamp_point_in_rect(movement_rect.polygon,global_position)
	global_position=pos
	pass;	
	
func clamp_point_in_rect(rect, point: Vector2) -> Vector2:
	var min_x = min(rect[0].x, rect[1].x, rect[2].x, rect[3].x)
	var max_x = max(rect[0].x, rect[1].x, rect[2].x, rect[3].x)
	var min_y = min(rect[0].y, rect[1].y, rect[2].y, rect[3].y)
	var max_y = max(rect[0].y, rect[1].y, rect[2].y, rect[3].y)
	
	return Vector2(clamp(point.x, min_x, max_x), clamp(point.y, min_y, max_y))
	


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print("exiting screen")
	queue_free()
	pass # Replace with function body.
