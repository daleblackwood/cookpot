extends Node

const max_player_count = 4
const move_trigger_sq = 0.2

@export_range(1, max_player_count) var player_count := 1

class InputSet:
	var move := Vector2.ZERO
	var view := Vector2.ZERO
	var primary := false
	var primary_fired := false
	var secondary := false
	var secondary_fired := false
	var trigger := false
	var move_fired := false
	var start := false
	var start_fired := false
	var back := false
	var back_fired := false
	
	func reset() -> void:
		move = Vector2.ZERO
		view = Vector2.ZERO
		primary = false
		primary_fired = false
		secondary = false
		secondary_fired = false
		trigger = false
		move_fired = false
		start = false
		start_fired = false
	
var mouse_delta = Vector2.ZERO
var sets: Array[InputSet] = []
var connected_joys: Array[int] = []

var blank_input = InputSet.new()

func _process(_delta: float):
	var mouse_move = mouse_delta * 0.1
	
	blank_input.reset()
	
	if sets.size() != player_count:
		sets.resize(player_count)
		for i in range(player_count):
			sets[i] = InputSet.new()
			
	connected_joys = Input.get_connected_joypads()
	
	for i in range(player_count):
		var step := sets[i]
		
		var prev_move = step.move
		var was_moving = step.move.length_squared() > move_trigger_sq
		var was_primary = step.primary
		var was_secondary = step.secondary
		var was_start = step.start
		var was_back = step.back
		
		step.reset()
		
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
			if Input.is_key_pressed(KEY_ENTER):
				step.start = true
			if Input.is_key_pressed(KEY_ESCAPE):
				step.back = true
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
			var jid := connected_joys[i]
			step.move.x += Input.get_joy_axis(jid, JOY_AXIS_LEFT_X)
			step.move.x += _bool_axis(Input.is_joy_button_pressed(jid, JOY_BUTTON_DPAD_LEFT), Input.is_joy_button_pressed(jid, JOY_BUTTON_DPAD_RIGHT))
			step.move.y += Input.get_joy_axis(jid, JOY_AXIS_LEFT_Y)
			step.move.y += _bool_axis(Input.is_joy_button_pressed(jid, JOY_BUTTON_DPAD_UP), Input.is_joy_button_pressed(jid, JOY_BUTTON_DPAD_DOWN))
			step.view.x += Input.get_joy_axis(jid, JOY_AXIS_RIGHT_X)
			step.view.y += Input.get_joy_axis(jid, JOY_AXIS_RIGHT_Y)
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_A) or Input.is_joy_button_pressed(jid, JOY_BUTTON_Y):
				step.primary = true
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_B) or Input.is_joy_button_pressed(jid, JOY_BUTTON_X):
				step.secondary = true
			if Input.get_joy_axis(jid, JOY_AXIS_TRIGGER_RIGHT) > 0.0 or Input.get_joy_axis(jid, JOY_AXIS_TRIGGER_LEFT) > 0.0:
				step.trigger = true
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_START):
				step.start = true
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_BACK):
				step.back = true
				
		if step.move.length_squared() > 1.0:
			step.move = step.move.normalized()
		
		if step.view.length_squared() > 1.0:
			step.view = step.view.normalized()
			
		step.primary_fired = step.primary and not was_primary
		step.secondary_fired = step.secondary and not was_secondary
		var is_moving =  step.move.length_squared() > move_trigger_sq
		step.move_fired = is_moving and (not was_moving or step.move.dot(prev_move) < 0.2)
		step.start_fired = step.start and not was_start
		step.back_fired = step.back and not was_back
	
			
func get_input(index: int) -> InputSet:
	if index < 0 or index >= sets.size():
		return blank_input
	return sets[index]
	

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
	
	
static func _key_axis(negative: Key, positive: Key) -> float:
	return _bool_axis(Input.is_key_pressed(negative), Input.is_key_pressed(positive))
	
static func _bool_axis(negative: bool, positive: bool) -> float:
	var result = 0.0
	if positive:
		result += 1.0
	if negative:
		result -= 1.0
	return result
