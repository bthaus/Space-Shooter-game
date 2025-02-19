extends Node2D
class_name GameObject
var event:Event
var player:PlayerShip
func _ready() -> void:
	pass
func hit():
	pass	
func _process(delta: float) -> void:
	translate(Vector2.DOWN*delta*100)
