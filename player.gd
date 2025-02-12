extends Spaceship
class_name PlayerShip

@export var movement_rect:Polygon2D

func _process(delta: float) -> void:
	super(delta)
	clamp_position()
	
func clamp_position():
	var pos=clamp_point_in_rect(movement_rect.polygon,global_position)
	print( pos)
	print(global_position)
	global_position=pos
	pass;	
	
func clamp_point_in_rect(rect, point: Vector2) -> Vector2:
	var min_x = min(rect[0].x, rect[1].x, rect[2].x, rect[3].x)
	var max_x = max(rect[0].x, rect[1].x, rect[2].x, rect[3].x)
	var min_y = min(rect[0].y, rect[1].y, rect[2].y, rect[3].y)
	var max_y = max(rect[0].y, rect[1].y, rect[2].y, rect[3].y)
	
	return Vector2(clamp(point.x, min_x, max_x), clamp(point.y, min_y, max_y))
	
