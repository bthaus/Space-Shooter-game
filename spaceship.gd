extends Node2D

@export var speed:float=100000
@onready var mesh=$SpaceShip/Spaceship
var reference_quat:Basis

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.max_fps=18
	reference_quat=Quaternion(mesh.transform.basis)
	pass # Replace with function body.

var twirling=Vector2.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction=Vector2.ZERO
	direction.x=Input.get_axis(&"ui_left",&"ui_right")
	direction.y=Input.get_axis(&"ui_up",&"ui_down")
	
	
	var move=direction
	if direction.length()<0.3:
		move=Vector2.ZERO
	$MultiViewPort/PArticles.toggle(move!=Vector2.ZERO or twirling!=Vector2.ZERO)
	var d=Input.get_axis(&"left_button",&"right_button")
	print(d)
	if d!=0 and twirling==Vector2.ZERO:
		get_tree().create_timer(0.2).timeout.connect(end_twirl)
		twirling+=Vector2(d*4,0)
	move(twirling,delta)
	move(direction,delta)	
	
	pass
func end_twirl():
	twirling=Vector2.ZERO
	pass;	
func move(direction,delta):
	rotate_mesh(direction,delta)
	
	translate(direction*speed*50*delta)
	pass	
func rotate_mesh(move:Vector2,delta):
	var speed=move.length_squared()
	print(speed)
	move=move.normalized()
	
	var rot=Vector3(move.y,0,-move.x)
	mesh.rotate(rot,delta*4*speed)
	var a=Quaternion(mesh.transform.basis)
	var b=a.slerp(reference_quat,delta*4)
	mesh.transform.basis=Basis(b)
	pass
