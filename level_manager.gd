extends Node2D
class_name LevelManager
@export var events:Array[Event]=[]
@export var entities:Array[PackedScene]
@export var spawn_polygon:Polygon2D
var spawn_points:Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_points=Array(spawn_polygon.polygon)
	pass # Replace with function body.

func select_next_event()-> Event:
	var e:Event 
	while not e:
		var temp = events.pick_random() as Event
		var chance=randf()
		if chance < temp.likelyhood:
			e=temp
	return e
	pass;
func spawn_entity(e):
	var q=e.instantiate()
	q.global_position=spawn_points.pick_random()
	add_sibling(q)
	pass;
func start_event():
	var event=select_next_event()
	var delay=0
	for i in range(event.duplications):
		for e in event.get_objects():
			get_tree().create_timer(delay).timeout.connect(spawn_entity.bind(e))
			delay+=randf_range(0,4)
	get_tree().create_timer(delay).timeout.connect(start_event)	
	pass;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
