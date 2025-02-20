extends Enemy
class_name Mothership
@export var lasers:Array[Sprite2D]=[]
var actions:Array[Callable]=[swarm,cascade,circle_attack]
var ship_buffer=[]
var count=0
# Called when the node enters the scene tree for the first time.

func die():
	player_data.mothership_destroyed=true
	super()
func _ready() -> void:
	MainScene.instance.prepare_boss_fight(self)
	if not active:return
	pick_attack(2)
	pass # Replace with function body.
func swarm():
	var angle=360/7
	var current=0
	for i in range(7):
		var f
		if ship_buffer.is_empty():
			f=flying_ship.instantiate()
		else:
			f=ship_buffer.pop_back()
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
		var f
		if ship_buffer.is_empty():
			f=flying_ship.instantiate()
		else:
			f=ship_buffer.pop_back()
		f.global_position=$MultiViewPort/rot/Shootpoint.global_position
		f.push_angle=current
		f.player=player
		f.immortal=true
		get_tree().create_timer(delay).timeout.connect(add_sibling.bind(f))
		current+=angle
		delay+=0.5
	pick_attack(12)	
	pass;
var flying_ship=load("res://following_enemy.tscn")
func circle_attack():
	if lasering:
		pick_attack(0)
		return
	lasering=true
	pick_attack(7)
	get_tree().create_timer(7).timeout.connect(func():lasering=false)
	pass;	
func pick_attack(timeout):
	count+=1
	if count==4:
		pick_attack(2)
		
	get_tree().create_timer(timeout).timeout.connect(actions.pick_random())
	pass;		
func _on_shoot_timer_timeout() -> void:
	ship_buffer.append(flying_ship.instantiate())
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.

func trigger_laser():
	var targets=[]
	for l in lasers:
		var area=l.get_child(0) as Area2D
		targets.append_array(area.get_overlapping_areas())
	if accum >0.3 and laser_power==1:
		accum=0
		for target in targets:
			
			if target.get_parent() == self:continue
			if target  and target.get_parent() is GameObject:
				target.get_parent().hit()
	pass
func show_laser(l=laser):
	var arms=$SpaceShip/origin/Camera3D.get_arm_positions()
	for i in range(arms.size()):
		super(lasers[i])
	pass;
func lower_laser(delta,mat=false):
	
	super(delta,true)
	var l=lasers.front()
	var cp=l.material.get_shader_parameter("progress")
	l.material.set_shader_parameter("progress",laser_power)
	for w in lasers:
		if cp<0.1:
			w.hide()
	
var lasering=false	
func _process(delta: float) -> void:
	if not active:return
	var center=$SpaceShip/origin/Camera3D.get_center() as Vector2
	var arms=$SpaceShip/origin/Camera3D.get_arm_positions()
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
	handle_laser(lasering,delta)
	
		
	#if  active:
		#translate(Vector2.DOWN/9*speed*50*delta)
	#$SpaceShip/origin/Spaceship.rotate(Vector3(0,1,0).normalized(),delta*0.03)
	#$MultiViewPort/rot.rotate(-delta*0.3)
	pass
