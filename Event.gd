extends Resource
class_name Event
@export var duplications=1
@export var difficulty_rating:float=1
@export var likelyhood=1.0
@export var objects:Array[PackedScene]=[]
@export var name:String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func instantiate_objects():
	
	pass;
func get_objects():
	return objects
	pass;	
func store():
	ResourceSaver.save(self)
	pass;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
