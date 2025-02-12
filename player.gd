extends Spaceship
class_name PlayerShip

@export var movement_rect:Polygon2D
func _process(delta: float) -> void:
	super(delta)
	if not active:return
	direction=Vector2.ZERO
	direction.x=Input.get_axis(&"ui_left",&"ui_right")
	direction.y=Input.get_axis(&"ui_up",&"ui_down")
	var move=direction
	var length=direction.length()
	if length<0.3:
		move=Vector2.ZERO
	$MultiViewPort/PArticles.toggle(move!=Vector2.ZERO or twirling!=Vector2.ZERO)
	$MultiViewPort/PArticles.set_ratio(length)
	if twirling:
		$MultiViewPort/PArticles.set_ratio(1)
	var d=Input.get_axis(&"left_button",&"right_button")
	if d!=0 and twirling==Vector2.ZERO:
		get_tree().create_timer(0.2).timeout.connect(end_twirl)
		twirling+=Vector2(d*4,0)
		$MultiViewPort/particles_boost.toggle(true)
	if not both_triggers_pressed():
		handle_shoot()
		handle_laser(delta)
	if both_triggers_pressed():
		lower_laser(delta)
		direction*=2.3
	move(twirling,delta)
	move(direction,delta)	
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
	
