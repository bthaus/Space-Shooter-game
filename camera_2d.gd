extends Camera2D

func _process(delta: float) -> void:
	if Input.is_action_pressed(&"scroll"):
		zoom *= 0.9
	if Input.is_action_pressed(&"scrollup"):
		zoom *= 1.1
