extends Node

const max_player_count = 4

@export_range(1, max_player_count) var player_count := 1

class InputSet:
	var move := Vector2.ZERO
	var view := Vector2.ZERO
	var primary := false
	var secondary := false
	var trigger := false
	
var mouse_delta = Vector2.ZERO
var sets: Array[InputSet] = []
var connected_joys: Array[int] = []


func _process(_delta: float):
	var mouse_move = mouse_delta * 0.1
	
	if sets.size() != player_count:
		sets.resize(player_count)
		for i in range(player_count):
			sets[i] = InputSet.new()
			
	connected_joys = Input.get_connected_joypads()
	
	for i in range(player_count):
		var step := sets[i]
		step.move = Vector2.ZERO
		step.view = Vector2.ZERO
		step.primary = false
		step.secondary = false
		step.trigger = false
		
		if i == 0:
			step.move.x += _key_axis(KEY_LEFT, KEY_RIGHT)
			step.move.y += _key_axis(KEY_UP, KEY_DOWN)
			step.view.x += _key_axis(KEY_COMMA, KEY_PERIOD)
	
			step.view.x += mouse_move.x
			step.view.y += mouse_move.y
			
			if Input.is_key_pressed(KEY_SPACE):
				step.primary = true
			if Input.is_key_pressed(KEY_ALT):
				step.secondary = true
			if Input.is_key_pressed(KEY_CTRL):
				step.trigger = true
		if i == 1 or (i == 0 and player_count < 2):
			step.move.x += _key_axis(KEY_A, KEY_D)
			step.move.y += _key_axis(KEY_W, KEY_S)
			step.view.x += _key_axis(KEY_Q, KEY_E)
			
			if Input.is_key_pressed(KEY_R):
				step.primary = true
			if Input.is_key_pressed(KEY_R):
				step.secondary = true
			if Input.is_key_pressed(KEY_SHIFT):
				step.trigger = true
				
		if i < connected_joys.size():
			var joy_id := connected_joys[i]
			step.move.x += Input.get_joy_axis(joy_id, JOY_AXIS_LEFT_X)
			step.move.y += Input.get_joy_axis(joy_id, JOY_AXIS_LEFT_Y)
			step.view.x += Input.get_joy_axis(joy_id, JOY_AXIS_RIGHT_X)
			step.view.y += Input.get_joy_axis(joy_id, JOY_AXIS_RIGHT_Y)
			if Input.is_joy_button_pressed(joy_id, JOY_BUTTON_A) or Input.is_joy_button_pressed(joy_id, JOY_BUTTON_Y):
				step.primary = true
			if Input.is_joy_button_pressed(joy_id, JOY_BUTTON_B) or Input.is_joy_button_pressed(joy_id, JOY_BUTTON_X):
				step.secondary = true
			if Input.get_joy_axis(joy_id, JOY_AXIS_TRIGGER_RIGHT) > 0.0 or Input.get_joy_axis(joy_id, JOY_AXIS_TRIGGER_LEFT) > 0.0:
				step.trigger = true
	
			
func get_input(index: int) -> InputSet:
	if index < 0 or index >= sets.size():
		return null
	return sets[index]
	

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
	
	
static func _key_axis(negative: Key, positive: Key) -> float:
	var result = 0.0
	if Input.is_key_pressed(positive):
		result += 1.0
	if Input.is_key_pressed(negative):
		result -= 1.0
	return result
