extends Sprite2D

var max
var vall
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_max_value(4)
	pass # Replace with function body.

func set_value(v:float):
	vall=v
	var val=remap(v,0.0,max,0.0,0.95)
	material.set_shader_parameter("value",val)
	
	pass;
func set_max_value(v):
	max=v
	vall=v
	material.set_shader_parameter("count",v)
	$underlay.material.set_shader_parameter("count",v)
	pass;	
