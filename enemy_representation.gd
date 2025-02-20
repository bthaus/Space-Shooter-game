extends HBoxContainer
@export var ship:Event
@export var rotating=true
@export var representation_scale=0.7
var d:PlayerData=load('res://Ressources/player_data.tres')
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not ship:
		set_player_ship()
		return
	var instance=ship.get_objects().front().instantiate()
	$SubViewport/Camera2D.active=rotating
	instance.active=false
	instance.scale*=representation_scale
	instance.translate(Vector2.RIGHT*100)
	$SubViewport.add_child(instance)
	$SubViewport/Camera2D.ship=instance
	$box/Name.text=$box/Name.text+ship.name
	$box/Likelyhood.text=$box/Likelyhood.text+str(ship.likelyhood)
	$box/Difficulty.text=$box/Difficulty.text+str(ship.difficulty_rating)
	$box/Count.text=$box/Count.text+str(ship.duplications)
	pass # Replace with function body.
func set_player_ship():
	var instance=load("res://Spaceship.tscn").instantiate()
	$SubViewport/Camera2D.active=rotating
	instance.active=false
	instance.scale*=representation_scale
	instance.translate(Vector2.RIGHT*100)
	$SubViewport/Camera2D.ship=instance
	$SubViewport.add_child(instance)
	$box/Name.text="This is your Ship"
	$box/Likelyhood.text="Numer of deaths: " +str(d.deaths)
	$box/Difficulty.text="Number of destroyed ships: "+str(d.ships_killed)
	$box/Count.text="Highscore: "+str(d.highest_score)
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
