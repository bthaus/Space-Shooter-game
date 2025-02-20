extends Enemy
class_name Mothership
@export var lasers:Array[Sprite2D]=[]
var actions:Array[Callable]=[swarm,cascade,circle_attack]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#cascade()
	#pick_attack(2)
	pass # Replace with function body.
func swarm():
	var angle=360/7
	var current=0
	for i in range(7):
		var f=load("res://following_enemy.tscn").instantiate()
		f.global_position=$MultiViewPort/rot/Shootpoint.global_position
		f.push_angle=current
		f.immortal=true
		add_sibling(f)
	
		current+=angle
		f.player=player
	pick_attack(7)	
	pass;
func cascade():
	var delay=0
	var angle=360/9
	var current=0
	for i in range(9):
		var f=load("res://following_enemy.tscn").instantiate()
		f.global_position=$MultiViewPort/rot/Shootpoint.global_position
		f.push_angle=current
		f.player=player
		f.immortal=true
		get_tree().create_timer(delay).timeout.connect(add_sibling.bind(f))
		current+=angle
		delay+=0.5
	pick_attack(12)	
	pass;

func circle_attack():
	
	pass;	
func pick_attack(timeout):
	get_tree().create_timer(timeout).timeout.connect(actions.pick_random())
	pass;		
func _on_shoot_timer_timeout() -> void:
	
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var center=$SpaceShip/origin/Camera3D.get_center() as Vector2
	var arms=$SpaceShip/origin/Camera3D.get_arm_positions()
	laser_power+=delta
	laser_power=clamp(laser_power,0,1)
	for i in range(arms.size()):
		var arm=arms[i]
		var v=true
		
		if v:
			lasers[i].z_index=4
		else:
			lasers[i].z_index=-1
		var an=arm.angle_to_point(center)
		
		lasers[i].rotation=an
		lasers[i].position=arm
		show_laser(lasers[i])
		
	#if  active:
		#translate(Vector2.DOWN/9*speed*50*delta)
	#$SpaceShip/origin/Spaceship.rotate(Vector3(0,1,0).normalized(),delta*0.03)
	#$MultiViewPort/rot.rotate(-delta*0.3)
	pass
