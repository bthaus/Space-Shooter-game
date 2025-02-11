extends GameObject
class_name Spaceship

@export var speed:float=30
@onready var mesh=$SpaceShip/origin/Spaceship
var reference_quat:Basis
static var offset=0
@export var active=true
@export var rotation_factor=10
@export var projectile:PackedScene
@onready var hp_bar:ProgressBar=$ProgressBar
@export var hp=3
# Called when the node enters the scene tree for the first time.
func hit():
	hp-=1
	hp_bar.value=hp
	if hp==0:
		queue_free()
	

func _ready() -> void:
	$SpaceShip/origin.translate(Vector3(offset,0,0))
	offset+=500
	Engine.max_fps=18
	hp_bar.max_value=hp
	hp_bar.value=hp
	reference_quat=Quaternion(mesh.transform.basis)
	pass # Replace with function body.
func get_projectile():
	return projectile.instantiate()
var twirling=Vector2.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
var accum=0.0
func _process(delta: float) -> void:
	if not active:return
	var direction=Vector2.ZERO
	direction.x=Input.get_axis(&"ui_left",&"ui_right")
	direction.y=Input.get_axis(&"ui_up",&"ui_down")
		
	if Input.is_action_just_pressed(&"shoot") and not Input.is_action_pressed(&'laser'):
		var p=get_projectile()
		p.visible=true
		add_sibling(p)
		p.global_position=$Shootpoint.global_position
		p.shoot(Vector2.UP)
		
	var move=direction
	var length=direction.length()
	
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
		laser_power+=delta/1.5
		accum+=delta
		laser_power=clamp(laser_power,0,1)
		var targets=$Raycast.get_overlapping_areas()
		#if target:
			#$laser.scale.x=(target.global_position-$Shootpoint.global_position).length()*0.5/50
			#$laser.global_position=lerp($Shootpoint.global_position,target.global_position,0.5)
		#else:
			#$laser.scale.x=16
			#$laser.global_position=$Shootpoint.global_position	
		if accum >0.3 and laser_power==1:
			for target in targets:
				if target  and target.get_parent() is GameObject:
					target.get_parent().hit()
				
		$laser.show()
		$laser.material.set_shader_parameter("progress",laser_power)
		$laser.scale.x=lerp(0,16,laser_power*2)
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
		if twirling!= Vector2.ZERO:
			mesh.rotate(rot,delta*24*speed)
		else:	
			mesh.rotate(rot,delta*rotation_factor*speed)
	var a=Quaternion(mesh.transform.basis)
	var b=a.slerp(reference_quat,delta*4)
	mesh.transform.basis=Basis(b)
	pass
