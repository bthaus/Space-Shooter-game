extends Node2D
class_name MainScene

static var instance:MainScene
static var highscore

var data=load("res://Ressources/player_data.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var temp=load("user://player_data.tres")
	if temp:data=temp
	
	instance=self
	if MainMenu.boss_please:
		$LevelManager.debug_event=load('res://Events/mothership.tres')
	$LevelManager.start_event()
	pass # Replace with function body.
func start_events():
	$Progress.hide()
	$LevelManager.boss_done=true
	$LevelManager.boss=false
	$LevelManager.start_event()
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
	$Highscore.text="Highscore: "+str(highscore)	
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_killbox_area_entered(area: Area2D) -> void:
	var p=area.get_parent()
	if p is Enemy:
		p.remove()
		return
	if p is PlayerShip: return
	if p is Projectile: p.queue_free()	
	pass # Replace with function body.
