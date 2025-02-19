extends Resource
class_name PlayerData
@export var player_name:String
var highest_score
@export var difficulty_rating_adjustment={}

func get_dr(wave):
	if not difficulty_rating_adjustment.has(wave) : return wave
	return difficulty_rating_adjustment[wave]
	pass;
func adjust_dr(game_rating,val):
	var current=difficulty_rating_adjustment.get(game_rating)
	if not current:
		difficulty_rating_adjustment[game_rating]=0
		current=0
	current=clamp(current+val,-200,200);
	difficulty_rating_adjustment[game_rating]=current
	ResourceSaver.save(self)
	pass;
