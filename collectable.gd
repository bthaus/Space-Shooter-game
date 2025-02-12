extends GameObject
class_name Collectable

var collected=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SubViewport/origin.translate(Vector3(Spaceship.offset,0,0))
	Spaceship.offset+=500
	super()
	pass # Replace with function body.


func hit():
	queue_free()
	pass;
func _on_area_2d_area_entered(area: Area2D) -> void:
	var p=area.get_parent()
	if p is Spaceship:
		apply_effect(p)
		collected=true
		$Area2D.queue_free()
		queue_free()
	pass # Replace with function body.
func apply_effect(s:Spaceship):
	s.apply_multishot()
