extends Camera2D
var ship:Spaceship
var active=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	pass # Replace with function body.

var rotated=false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not active:return
	if not ship:return
	if not rotated:
		ship.mesh.rotate(Vector3(0,1,-0.5).normalized(),deg_to_rad(90))
		rotated=true
	ship.mesh.rotate(Vector3(0.01,0,0.1).normalized(),delta)
	pass
