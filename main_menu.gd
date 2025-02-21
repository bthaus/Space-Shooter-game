extends Node2D
class_name MainMenu
static var boss_please=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data=load("res://Ressources/player_data.tres")
	$Highscore.text="Highscore: "+str(data.highest_score)
	if data.mothership_destroyed:
		$mothership_destroyed.show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	boss_please=false
	get_tree().change_scene_to_file('res://main.tscn')
	pass # Replace with function body.


func _on_graphs_pressed() -> void:
	get_tree().change_scene_to_file('res://graphs.tscn')
	pass # Replace with function body.


func _on_enemies_pressed() -> void:
	get_tree().change_scene_to_file('res://enemy_stats.tscn')
	pass # Replace with function body.


func _on_start_2_pressed() -> void:
	boss_please=true
	get_tree().change_scene_to_file('res://main.tscn')
	pass # Replace with function body.
