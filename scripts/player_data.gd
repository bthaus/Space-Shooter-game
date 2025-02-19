extends Resource
class_name PlayerData
@export var player_name:String
var highest_score
@export var difficulty_rating_adjustment={}

func get_dr(wave):
	if not difficulty_rating_adjustment.has(wave) : return wave
	return difficulty_rating_adjustment[wave]
	pass;
func adjust_dr(wave,val):
	var current=difficulty_rating_adjustment.get(wave)
	if not current:
		difficulty_rating_adjustment[wave]=0
		current=0
	current=clamp(current+val,-200,200);
	difficulty_rating_adjustment[wave]=current
	ResourceSaver.save(self)
	pass;

func accumulate(accum,data):
	if not data: return accum
	return accum+data
	pass;	
	
func calculate_next_dr(wave):
	if not difficulty_rating_adjustment.has(wave-1): return 0
	var relevant_waves=difficulty_rating_adjustment.values()
	relevant_waves.resize(wave-1)
	
	#take average of last waves
	var average=relevant_waves.reduce(accumulate,0)/relevant_waves.size()+1
	print("average of all waves: "+str(average))
	#weigh last 3 waves more strongly
	if relevant_waves.size()>3:
		var last=relevant_waves
		last=[last.pop_back(),last.pop_back(),last.pop_back()]
		var weighed:float=last.reduce(accumulate,0)/3
		average=lerp(average,weighed,0.3)
	
	#adjust the average to the dra of the last time this wave has been reached
	if difficulty_rating_adjustment.has(wave):
		var last=difficulty_rating_adjustment.get(wave)
		average=lerp(average,last,0.5)
	print("weighed average: "+str(average))	
	return average	
	pass;
