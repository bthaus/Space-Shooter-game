extends GameObject
class_name Spaceship

@export var speed:float=30
@onready var mesh=$SpaceShip/origin/Spaceship
var reference_quat:Basis
static var offset=0
@export var active=true
@export var rotation_factor=10
@export var projectile:PackedScene

@export var hp:float=3
var max_hp:float

# Called when the node enters the scene tree for the first time.
func hit():
	change_health(-1)
func change_health(val):
	hp+=val
	$Progress.set_value(hp)
	var shield_Val=remap(hp,1,max_hp,0,1)
	$Shield.material.set_shader_parameter("dissolve_value", shield_Val)
	if hp==0:
		queue_free()	
var multishot=false	
func apply_multishot():
	multishot=true
	directions=[Vector2.UP,
	Vector2(-2,-1).normalized(),
	Vector2(-1,-1).normalized(),
	Vector2(2,-1).normalized(),
	Vector2(1,-1).normalized(),
	Vector2.UP]
	get_tree().create_timer(20).timeout.connect(remove_multishot)
	
	pass;
func remove_multishot():
	multishot=false
	directions=[Vector2.UP]	
	pass;
var fly_buff=false		
func apply_fly():
	get_tree().create_timer(7).timeout.connect(remove_fly)
	fly_buff=true
	pass;	
func remove_fly():
	fly_buff=false
	pass;	
func _ready() -> void:
	$SpaceShip/origin.translate(Vector3(offset,0,0))
	offset+=500
	#Engine.max_fps=18
	max_hp=hp
	$Progress.set_max_value(hp)
	$Progress.set_value(hp)
	reference_quat=Quaternion(mesh.transform.basis)
	pass # Replace with function body.
func get_projectile():
	return projectile.instantiate()
var twirling=Vector2.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
var accum=0.0
func handle_shoot():
	if Input.is_action_just_pressed(&"shoot") and not Input.is_action_pressed(&'laser'):
		shoot()
	pass;
var directions=[Vector2.UP]	
func shoot():
	
	for d in directions:
		var p=get_projectile()
		p.visible=true
		add_sibling(p)
		p.shooter=self
		p.global_position=$MultiViewPort/rot/Shootpoint.global_position
		p.shoot(d)
		
	pass;
	
var direction=Vector2.ZERO
func both_triggers_pressed():
	return Input.is_action_pressed(&"laser") and Input.is_action_pressed(&"shoot")
	
func lower_laser(delta):
	laser_power-=delta
	accum-=delta
	var cp=$MultiViewPort/rot/laser.material.get_shader_parameter("progress")
	if cp<0.1:
		$MultiViewPort/rot/laser.hide()
	$MultiViewPort/rot/laser.material.set_shader_parameter("progress",laser_power)	
func _process(delta: float) -> void:
	
	super(delta)
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
	speed=clamp(speed,0,1.7)
	move=move.normalized()
	if move:
		
		var rot=Vector3(move.y,0,-move.x)
		if twirling!= Vector2.ZERO:
			mesh.rotate(rot,delta*24*speed)
		else:	
			mesh.rotate(rot,delta*rotation_factor*speed)
	var a=Quaternion(mesh.transform.basis)
	var b=a.slerp(reference_quat,delta*4)
	mesh.transform.basis=Basis(b)
	pass
