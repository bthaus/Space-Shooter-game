extends Resource
class_name PlayerData
@export var player_name:String
@export var highest_score=0
@export var highscore=0
@export var ships_killed=0
@export var deaths=0
@export var difficulty_rating_adjustment={}
@export var mothership_destroyed=false
func get_dr(wave):
	if not difficulty_rating_adjustment.has(wave) : return wave
	return difficulty_rating_adjustment[wave].front()
	pass;
func reset():
	difficulty_rating_adjustment={}	
	ResourceSaver.save(self)
func adjust_dr(wave,val):
	if MainMenu.boss_please:return
	var current=difficulty_rating_adjustment.get_or_add(wave,[0])
	print("change wave"+str(wave)+ "from "+str(current.front()))
	current=clamp(current.front()+val,-200,200);
	print("to "+str(current))
	difficulty_rating_adjustment[wave].push_front(current)
	var arr:Array=difficulty_rating_adjustment[wave]
	if arr.size()>100:arr.resize(100)
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
	if MainMenu.boss_please:return 1
	if not difficulty_rating_adjustment.has(wave-1): return 0
	var relevant_waves=difficulty_rating_adjustment.values()
	relevant_waves.resize(wave-1)
	
	#take average of last waves
	var average=relevant_waves.reduce(accumulate,0)/relevant_waves.size()+1

	#weigh last 3 waves more strongly
	if relevant_waves.size()>3:
		var last=relevant_waves
		last=[last.pop_back(),last.pop_back(),last.pop_back()]
		var weighed:float=last.reduce(accumulate,0)/3
		average=lerp(average as float,weighed as float,0.3)
	
	#adjust the average to the dra of the last times this wave has been reached
	if difficulty_rating_adjustment.has(wave):
		var history=difficulty_rating_adjustment.get(wave)
		var laver=history.reduce(accumarray,0)
		var last:float=laver/difficulty_rating_adjustment.get(wave).size()
		average=lerp(average as float,last as float,0.5)

	#factor remaining health -> a lot of health, harder wave.
	average-=lost_health	
	
	return average	
	pass;
