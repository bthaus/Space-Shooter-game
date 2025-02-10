extends Node3D
class_name Texturizer
static var instance:Texturizer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
static func set_instance():
	if instance: return instance
	instance=load('res://texturiser.tscn').instantiate()
	return instance
	pass	
static func get_spaceship():
	set_instance()
	var port=instance.get_node("SpaceShip") as SubViewport
	return port.get_texture()
	
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
