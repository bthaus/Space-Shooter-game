extends Node2D
@export var buffs:Buffs

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buffs=load("res://Buffs.tres")
	var temp=ResourceLoader.load("user://Buffs.tres")
	if temp:buffs=temp
	$multhishot.button_pressed=buffs.multishot
	$laser.button_pressed=buffs.flying
	$invincible.button_pressed=buffs.invincible
	$hp.value=buffs.hp
	$speed_slider.value=buffs.gamespeed
	$hp_val.text=str($hp.value)
	$speed.text=str($speed_slider.value)+"%"
	$difftext.text=str(buffs.diff)
	$diff_slider.value=buffs.diff
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	


func _on_apply_pressed() -> void:
	buffs.multishot=$multhishot.button_pressed
	buffs.flying=$laser.button_pressed
	buffs.invincible=$invincible.button_pressed
	buffs.hp=$hp.value
	buffs.gamespeed=$speed_slider.value
	buffs.diff=$diff_slider.value
	
	ResourceSaver.save(buffs,"user://Buffs.tres")
	pass # Replace with function body.


func _on_reset_pressed() -> void:
	buffs.reset()
	ResourceSaver.save(buffs,"user://Buffs.tres")
	_ready()
	pass # Replace with function body.


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
	pass # Replace with function body.


func _on_hp_value_changed(value: float) -> void:
	$hp_val.text=str(value)
	pass # Replace with function body.


func _on_speed_slider_value_changed(value: float) -> void:
	$speed.text=str(value)+"%"
	pass # Replace with function body.


func _on_speed_slider_2_value_changed(value: float) -> void:
	$difftext.text=str(value)
	pass # Replace with function body.
