extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file('res://main.tscn')
	pass # Replace with function body.


func _on_graphs_pressed() -> void:
	get_tree().change_scene_to_file('res://graphs.tscn')
	pass # Replace with function body.


func _on_enemies_pressed() -> void:
	get_tree().change_scene_to_file('res://enemy_stats.tscn')
	pass # Replace with function body.
