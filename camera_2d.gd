extends Camera2D

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= 0.9
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= 1.1
