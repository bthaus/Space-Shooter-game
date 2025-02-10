extends Node2D

@export var speed:float=100
@onready var mesh=$SpaceShip/Spaceship
var reference_quat:Basis
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reference_quat=Quaternion(mesh.transform.basis)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction=Vector2.ZERO
	direction.x=Input.get_axis(&"ui_left",&"ui_right")
	direction.y=Input.get_axis(&"ui_up",&"ui_down")
	var move=direction.normalized()
	rotate_mesh(move,delta)
	
	translate(move*speed)
	pass
func rotate_mesh(move:Vector2,delta):
	var rot=Vector3(move.y,0,-move.x)
	mesh.rotate(rot,delta*4)
	var a=Quaternion(mesh.transform.basis)
	var b=a.slerp(reference_quat,0.1)
	mesh.transform.basis=Basis(b)
	pass
