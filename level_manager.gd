extends Node2D
class_name LevelManager
@export var events:Array[Event]=[]
@export var entities:Array[PackedScene]
@export var spawn_polygon:Polygon2D
@export var playerData:PlayerData=preload('res://Ressources/player_data.tres')
@export var player:PlayerShip
@export var debug_event:Event
var spawn_points:Array

var wave=1
var current_power_level=2.0:
	set(val):
		current_power_level=val
		$PowerLevel/Label.text=str(current_power_level)
var current_events=[]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if debug_event:
		events.clear()
		events.append(debug_event)
	spawn_points=Array(spawn_polygon.polygon)
	pass # Replace with function body.
func too_high_event_level(item:Event):
	return item.difficulty_rating>current_power_level/2
func select_next_event()-> Array[Event]:
	var selected_events:Array[Event]=[]
	var wave_difficulty=0 
	var with_buf=false
	while wave_difficulty<current_power_level:
		var temp = events.pick_random()
		if temp.difficulty_rating<0:
			if with_buf:continue
			with_buf=true
		if temp.difficulty_rating>current_power_level/2:
			if not events.all(too_high_event_level):
				continue
			else:
				var smallest=1000000
				for e in events:
					if e.difficulty_rating<smallest:
						temp=e
						smallest=e.difficulty_rating
		var chance=randf()
		if chance < temp.likelyhood:
			selected_events.append(temp)
		wave_difficulty+=temp.difficulty_rating	
	return selected_events
	pass;
func spawn_entity(e,event):
	var q=e.instantiate()
	q.player=player
	q.global_position=spawn_points.pick_random()
	add_sibling(q)
	pass;
	
func increase_power_level():
	wave+=1
	current_power_level=wave+playerData.get_dr(wave)
	
	update_event_tags()
	pass;	
func update_event_tags():
	$events.text=""
	for event in events:
		$events.text=$events.text+event.name+" with "+str(event.get_objects().size())+" es and rating" +str(event.difficulty_rating)+ "\n"
		
	pass;	
func start_event():
	increase_power_level()
	var events=select_next_event()
	current_events.push_back(events)
	if current_events.size()>3:
		var remove=current_events.pop_back()
		change_event_difficulty(-1,remove,false)
	var delay=0
	var longest_delay=0
	update_event_tags()
	for event in events:
		if longest_delay<=delay:
			longest_delay=delay
		delay=0
		for i in range(event.duplications):
			for e in event.get_objects():
				get_tree().create_timer(delay).timeout.connect(spawn_entity.bind(e,event))
				delay+=randf_range(0,4)
				if debug_event:return
	get_tree().create_timer(longest_delay).timeout.connect(start_event)	
	pass;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func change_event_difficulty(val,es,dirty):
	var changed_events=[]
	for e:Event in es:
			if changed_events.has(e):continue
			changed_events.push_back(e)
			e.difficulty_rating=clamp(e.difficulty_rating+val,0.3,200)
			e.dirty=dirty
			ResourceSaver.save(e)
	update_event_tags()		
	pass;
func change_current_difficulty(val):
	playerData.adjust_dr(current_power_level,-val)
	for es in current_events:
		change_event_difficulty(val,es,true)
			
func _on_player_player_died() -> void:
	change_current_difficulty(1)
	pass # Replace with function body.


func _on_player_player_hit() -> void:
	change_current_difficulty(0.3)
	pass # Replace with function body.
