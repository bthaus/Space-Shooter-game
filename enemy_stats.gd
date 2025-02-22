extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file('res://main_menu.tscn')
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	for c in $ScrollContainer/VBoxContainer.get_children():
		if c is EnemyRepresentation:
			if not c.ship:continue
			c.ship.difficulty_rating=c.ship.original_diff
			c.ship.store()
	get_tree().reload_current_scene()	
	pass # Replace with function body.
