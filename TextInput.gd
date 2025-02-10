extends Node;
class_name InputCycler;

signal on_letter_press(letter:int);
signal on_number_press(number:int);

const _a_key:int = 65;
const _z_key:int = 90;
const _zero_key:int = 48;
const _nine_key:int = 57;
const num_nine:int=4194447
const num_zero:int=4194439
var num_pressed=false
var let_pressed=false	
func _input(event: InputEvent) -> void:
	if event.is_echo():return
	
	if event is InputEventKey and event.pressed:
		print(event.keycode)
		_handle_key(event.keycode);
		
	return;
	
func _handle_key(key:int) ->void:
	if key >= _a_key && key <= _z_key:
		on_letter_press.emit(key);
		return;
	
	if key >= _zero_key && key <= _nine_key:
		on_number_press.emit(key);
		return;
	
	return;


func _on_on_letter_press(letter: int) -> void:
	pass # Replace with function body.
