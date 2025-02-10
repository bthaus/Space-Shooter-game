extends Node2D
class_name Spaceship

@export var speed:float=30
@onready var mesh=$SpaceShip/origin/Spaceship
var reference_quat:Basis
static var offset=0
@export var active=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpaceShip/origin.translate(Vector3(offset,0,0))
	offset+=500
	Engine.max_fps=18
	reference_quat=Quaternion(mesh.transform.basis)
	pass # Replace with function body.

var twirling=Vector2.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not active:return
	var direction=Vector2.ZERO
	direction.x=Input.get_axis(&"ui_left",&"ui_right")
	direction.y=Input.get_axis(&"ui_up",&"ui_down")
		
	if Input.is_action_just_pressed(&"shoot") and not Input.is_action_pressed(&'laser'):
		var p=$projectile_plasma.duplicate()
		p.visible=true
		get_parent().add_child(p)
		p.shoot(Vector2.UP)
		p.global_position=global_position
	var move=direction
	var length=direction.length()
	print(length)
	if length<0.3:
		move=Vector2.ZERO
	$MultiViewPort/PArticles.toggle(move!=Vector2.ZERO or twirling!=Vector2.ZERO)
	$MultiViewPort/PArticles.set_ratio(length)
	if twirling:
		$MultiViewPort/PArticles.set_ratio(1)
	var d=Input.get_axis(&"left_button",&"right_button")
	
	if d!=0 and twirling==Vector2.ZERO:
		get_tree().create_timer(0.2).timeout.connect(end_twirl)
		twirling+=Vector2(d*4,0)
		$MultiViewPort/particles_boost.toggle(true)
	if Input.is_action_pressed(&'laser'):
		direction=Vector2.ZERO
		twirling=direction
		laser_power+=delta
		laser_power=clamp(laser_power,0,1)
		$laser.show()
		$laser.material.set_shader_parameter("progress",laser_power)
	else:
		laser_power-=delta
		var cp=$laser.material.get_shader_parameter("progress")
		if cp<0.1:
			$laser.hide()
		$laser.material.set_shader_parameter("progress",laser_power)	
	move(twirling,delta)
	move(direction,delta)	
	
	pass
var laser_power=0.0	
func end_twirl():
	twirling=Vector2.ZERO
	pass;	
func move(direction,delta):
	rotate_mesh(direction,delta)
	
	translate(direction*speed*50*delta)
	pass	
func rotate_mesh(move:Vector2,delta):
	
	var speed=move.length_squared()
	
	move=move.normalized()
	if move:
		var rot=Vector3(move.y,0,-move.x)
		mesh.rotate(rot,delta*4*speed)
	var a=Quaternion(mesh.transform.basis)
	var b=a.slerp(reference_quat,delta*4)
	mesh.transform.basis=Basis(b)
	pass
