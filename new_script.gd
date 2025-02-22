extends Resource
class_name Buffs
@export var multishot=false
@export var flying=false
@export var invincible=false
@export var hp=5
@export var gamespeed=100
@export var diff:float=1


func reset():
	multishot=false
	flying=false
	invincible=false
	hp=5
	diff=1
	gamespeed=100
	ResourceSaver.save(self,"user://Buffs.tres")
	
