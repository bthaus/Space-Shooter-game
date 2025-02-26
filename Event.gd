extends Resource
class_name Event
@export var duplications:float=1
@export var difficulty_rating:float=1
@export var likelyhood:float=1.0
@export var objects:Array[PackedScene]=[]
@export var name:String
@export var dirty=false
@export var is_buff=false
@export var original_diff:float
var data:Eventtemp
var pool=[]
func get_user_data():
	var temp=load("user://"+name+"new.tres")
	if temp: return temp
	store()
	return self
func _init() -> void:
	data=load("user://"+name+".tres")
	
	#if not data:
		#print("create standart data")
		#data=Eventtemp.new()
		#data.count=duplications
		#data.dr=difficulty_rating
		#data.likelihood=likelyhood
		#store()
	#else:
		#print("load data")
		#duplications=data.count
		#difficulty_rating=data.dr
		#likelyhood=data.likelihood

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
func instantiate_objects(val=1):
	for i in range(val):
		pool.append(objects.front().instantiate())
		if pool.size()>15:return
	pass;
func get_objects():
	if pool.size()<7:
		call_deferred("instantiate_objects")
	if pool.is_empty():
		return [objects.front().instantiate()]
	
	return [pool.pop_back()]
	pass;	
func store():
	
	print(ResourceSaver.save(self,"user://"+name+"new.tres"))
	pass;
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
