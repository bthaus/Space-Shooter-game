extends Node2D
class_name GameObject
var event:Event
var player:PlayerShip
var player_data:PlayerData=load("res://Ressources/player_data.tres")
@export var active=true
func _ready() -> void:
	pass
func hit():
	return false
	pass	
func _process(delta: float) -> void:
	if not active:return
	translate(Vector2.DOWN*delta*100)
