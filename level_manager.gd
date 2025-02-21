extends Node2D
class_name LevelManager
@export var events:Array[Event]=[]
@export var entities:Array[PackedScene]
@export var spawn_polygon:Polygon2D
@export var playerData:PlayerData=preload('res://Ressources/player_data.tres')
@export var player:PlayerShip
@export var debug_event:Event
@export var wave_easing=1
@export var hit_easing=0.5
@export var death_easing=2
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
	if item.is_buff:
		return true
	return item.difficulty_rating>current_power_level/2 
func select_next_event()-> Array[Event]:
	var selected_events:Array[Event]=[]
	var wave_difficulty=0 
	var with_buf=false
	if debug_event: return [debug_event]
	while wave_difficulty<current_power_level:
		var temp = events.pick_random()
		if temp.is_buff:
			if with_buf:continue
			with_buf=true
		if temp.difficulty_rating>current_power_level/2:
			if not events.all(too_high_event_level):
				continue
			else:
				var smallest=1000000
				for e in events:
					if e.is_buff:continue
					if e.difficulty_rating<smallest :
						temp=e
						smallest=e.difficulty_rating
		var chance=randf()
		if chance < temp.likelyhood:
			selected_events.append(temp)
		wave_difficulty+=temp.difficulty_rating	
	return selected_events
	pass;
func spawn_entity(e,event):
	
	if not player:return
	var q=e.instantiate()
	q.player=player
	q.global_position=spawn_points.pick_random()
	if debug_event: q.global_position=player.global_position+Vector2.UP*3000
	add_sibling(q)
	pass;



	
func increase_power_level():
	if not player:return
	wave+=1
	current_power_level=wave+playerData.calculate_next_dr(wave,player.max_hp-player.hp)
	
	update_event_tags()
	pass;	
func update_event_tags():

	pass;	
var dirty=false	
func start_event():
	if not dirty:playerData.adjust_dr(wave,wave_easing)	
	else:dirty=false
	increase_power_level()
	var events=select_next_event()
	current_events.push_back(events)
	if current_events.size()>3:
		var remove=current_events.pop_back()
		change_event_difficulty(wave_easing,remove,false)
	
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
		if e.is_buff:continue
		if changed_events.has(e):continue
		#entities are made dirty on receiving damage. if a wave is over, event difficulty is lowered with dirty false
		#if the diff has been raised however, the diff wont be lowered, indicated by dirty. if the wave is over, dirty is consumed
		if e.dirty and dirty: e.dirty=false; continue;
		changed_events.push_back(e)
		e.difficulty_rating=clamp(e.difficulty_rating+val*0.01,0.3,200)
		e.dirty=dirty
		ResourceSaver.save(e)
	update_event_tags()		
	pass;
func change_current_difficulty(val):
	playerData.adjust_dr(wave,-val)
	for es in current_events:
		change_event_difficulty(val,es,true)
			
func _on_player_player_died() -> void:
	change_current_difficulty(death_easing)
	pass # Replace with function body.


func _on_player_player_hit() -> void:
	dirty=true
	change_current_difficulty(hit_easing)
	pass # Replace with function body.
