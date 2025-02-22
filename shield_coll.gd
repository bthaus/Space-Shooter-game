extends Collectable
class_name ShieldCollectable


func apply_effect(s:Spaceship):
	s.add_max_health(1)
	s.change_health(1)
	
	
