extends Node2D
class_name MainScene
var data=load("res://Ressources/player_data.tres")
static var instance:MainScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	instance=self
	if MainMenu.boss_please:
		$LevelManager.debug_event=load('res://Events/mothership.tres')
	$LevelManager.start_event()
	pass # Replace with function body.

func prepare_boss_fight(ship:Mothership):
	print("prep boss fight")
	create_tween().tween_property($Camera2D,"zoom",Vector2(0.13,0.13),3)
	$Progress.show()
	$Progress.set_max_value(ship.hp)
	$Progress.set_value(ship.hp)
	ship.ship_hit.connect(func():
		$Progress.set_value(ship.hp))
	$Player.movement_rect=$Polygon2D2	
	
	pass;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed(&"restart"):
		get_tree().reload_current_scene()
	$Highscore.text="Highscore: "+str(data.highscore)	
	pass
