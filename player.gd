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
	player_data.deaths+=1
	ResourceSaver.save(player_data)
	active=false
	player_died.emit()
	super()
	get_tree().change_scene_to_file("res://main_menu.tscn")
	pass;	
func _ready() -> void:
	super()
func shoot():
	if multishot:
		var d=directions.front()
		directions.append(d.rotated(deg_to_rad(45)).normalized())
		directions.append(d.rotated(deg_to_rad(25)).normalized())
		directions.append(d.rotated(deg_to_rad(-45)).normalized())
		directions.append(d.rotated(deg_to_rad(-25)).normalized())
	super()
	pass;
var angle=0.0	
var new_direction=Vector2.ZERO
func add_hit():
	player_data.ships_killed+=1
	pass;
func handle_laser(active,delta):
	if Input.is_action_pressed(&'laser'):
		if not fly_buff:
			new_direction=Vector2.ZERO
			twirling=Vector2.ZERO
	super(active,delta)		
		
func _process(delta: float) -> void:
	super(delta)
	if not active:return
	
	#if Input.is_action_just_pressed(&"repel"):
		#var projectiles=$repelbox.get_overlapping_areas().filter(func (item):return item.get_parent() is Projectile and item.get_parent().shooter!=self)
		#for p in projectiles:
			#var projectile=p.get_parent() as Projectile
			#projectile.direction*=-1
			
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
	$MultiViewPort/rot/PArticles.show()
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
		handle_laser(Input.is_action_pressed(&'laser'),delta)
	
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
	
	pass # Replace with function body.
