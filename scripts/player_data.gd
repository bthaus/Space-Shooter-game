extends Resource
class_name PlayerData
@export var player_name:String
var highest_score
@export var difficulty_rating_adjustment={}

func get_dr(wave):
	if not difficulty_rating_adjustment.has(wave) : return wave
	return difficulty_rating_adjustment[wave].front()
	pass;
func adjust_dr(wave,val):
	var current=difficulty_rating_adjustment.get_or_add(wave,[0])
	current=clamp(current.front()+val,-200,200);
	difficulty_rating_adjustment[wave].push_front(current)
	ResourceSaver.save(self)
	pass;

func accumulate(accum,data):
	if not data: return accum
	return accum+data.front()
	pass;	
func accumarray(accum,data):
	if not data: return accum
	return accum+data
	pass;	
func calculate_next_dr(wave,lost_health):
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
	
	#adjust the average to the dra of the last times this wave has been reached
	if difficulty_rating_adjustment.has(wave):
		var history=difficulty_rating_adjustment.get(wave)
		var laver=history.reduce(accumarray,0)
		var last=laver/difficulty_rating_adjustment.get(wave).size()
		average=lerp(average,last,0.5)
	print("weighed average: "+str(average))	
	#factor remaining health -> a lot of health, harder wave.
	average-=lost_health	
	print("lost health change")
	return average	
	pass;
