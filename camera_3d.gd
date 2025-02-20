extends Camera3D

@export var arms:Array[Node3D]=[]
@export var center:Node3D
func get_arm_positions():
	var arr=[]
	for a in arms:
		arr.append(unproject_position(a.global_transform.origin))
		
	return arr	
	pass
func get_center():
	return unproject_position(center.global_transform.origin)
	pass
func is_point_visible(i):
	if i==0:
		print(arms[i].global_position.z)
	return true
	
