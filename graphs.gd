extends Node2D
@onready var playerdata:PlayerData=load("res://Ressources/player_data.tres")
@export var graph:Graph2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	
	
	var data=playerdata.difficulty_rating_adjustment
	for i in range(data.size()):
		if not data.has(i):continue
		var sub_graph=Graph2D.new()
		sub_graph.background_color=Color.TRANSPARENT
		sub_graph.custom_minimum_size.y=500
		graph.add_sibling(sub_graph)
		
		sub_graph.y_min=data[i].min()
		sub_graph.y_max=data[i].max()
		sub_graph.x_label="History of wave "+str(i)
		sub_graph.x_max=data[i].size()
		var item=sub_graph.add_plot_item("History of wave_adjustments")
		for j in range(data[i].size()):
			#if not data[i].has(j):continue
			print("add ")
			print(Vector2(j,data[i][j]))
			item.add_point(Vector2(j,data[i][j]))
		
	graph.x_max=data.size()
	graph.x_min=1
	var item=graph.add_plot_item("difficulty_adjustment")
	for i in range(data.size()):
		if not data.has(i):continue
		item.add_point(Vector2(i,data[i].front()))
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
