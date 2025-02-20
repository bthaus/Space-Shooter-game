extends Node2D
@onready var playerdata:PlayerData=load("res://Ressources/player_data.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	set_up()
	
	pass # Replace with function body.

func set_up():
	for child in $ScrollContainer/VBoxContainer.get_children():
		if child == $ScrollContainer/VBoxContainer/Label:continue
		child.queue_free()
	var b=Button.new()
	b.text="Back"
	b.pressed.connect(_on_button_pressed)
	$ScrollContainer/VBoxContainer.add_child(b)
	var b2=Button.new()
	b2.text="Reset Data"
	b2.pressed.connect(reset_data)
	$ScrollContainer/VBoxContainer.add_child(b2)
	var data=playerdata.difficulty_rating_adjustment
	var graph=Graph2D.new()
	
	$ScrollContainer/VBoxContainer.add_child(graph)
	graph.custom_minimum_size.y=500
	graph.background_color=Color.TRANSPARENT
	graph.x_label="Wave"
	
	graph.x_max=data.size()
	graph.x_min=1
	graph.y_min=-5
	graph.y_max=5
	var item1=graph.add_plot_item("difficulty_adjustment")
	for i in range(data.size()):
		if not data.has(i):continue
		item1.add_point(Vector2(i,data[i].front()))
		
	for i in range(data.size()):
		#i=data.size()-i
		if not data.has(i):continue
		var sub_graph=Graph2D.new()
		sub_graph.background_color=Color.TRANSPARENT
		sub_graph.custom_minimum_size.y=500
		$ScrollContainer/VBoxContainer.add_child(sub_graph)
		var button=Button.new()
		button.text="make wave "+str(i)+" more difficult by 1"
		button.pressed.connect(func():
			playerdata.adjust_dr(i,1)
		
			set_up()
			
			)
		$ScrollContainer/VBoxContainer.add_child(button)
		var button2=Button.new()
		button2.text="make wave "+str(i)+" less difficult by 1"
		button2.pressed.connect(func():
			playerdata.adjust_dr(i,-1)
			
			set_up()
			
			)
		$ScrollContainer/VBoxContainer.add_child(button2)
				
		sub_graph.y_min=data[i].min()
		sub_graph.y_max=data[i].max()
		sub_graph.x_label="History of wave "+str(i)
		sub_graph.x_max=data[i].size()
		var item=sub_graph.add_plot_item("History of wave_adjustments")
		var d=data[i].duplicate()
		d.reverse()
		for j in range(data[i].size()):
			#if not data[i].has(j):continue
			print("add ")
			print(Vector2(j,d[j]))
			item.add_point(Vector2(j,d[j]))
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func reset_data():
	playerdata.reset()
	set_up()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
	pass # Replace with function body.
