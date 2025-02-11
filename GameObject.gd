extends Node2D
class_name GameObject


func _ready() -> void:
	print(name+ " ready.")
	
func hit():
	pass	
func _process(delta: float) -> void:
	translate(Vector2.DOWN*delta*100)
