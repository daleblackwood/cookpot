extends Node

const PLAYER_LIMIT := 16
const MOVE_TRIGGER_SQ = 0.1
const IGNORED_JOY_NAMES := ["wheel", "pedal", "shifter", "handbrake", "racing"]

@export_range(1, PLAYER_LIMIT) var player_slot_count := 1
	
var mouse_delta = Vector2.ZERO
var sets: Array[CookInputSet] = []
var connected_joys: Array[int] = []
var mouse_mode := 0
var has_focus := true
var had_focus := false
var mouse_mode_captured := Input.MOUSE_MODE_CAPTURED
var mouse_mode_uncaptured := Input.MOUSE_MODE_VISIBLE
var is_capturing := false

var blank_input = CookInputSet.new()
var all_input = CookInputSet.new()

func _process(_delta: float):
	var mouse_move = mouse_delta * 0.1
	
	blank_input.reset()
	
	if sets.size() != player_slot_count:
		sets.resize(player_slot_count)
		for i in range(player_slot_count):
			sets[i] = CookInputSet.new()
			
	connected_joys.assign(Input.get_connected_joypads().filter(_is_gamepad))
	
	for i in range(player_slot_count):
		var step := sets[i]
		
		var prev_move = step.move
		var prev_actions = step.states.duplicate()
		
		step.reset()
		
		if i == 0:
			step.move.x += _key_axis(KEY_LEFT, KEY_RIGHT)
			step.move.y += _key_axis(KEY_UP, KEY_DOWN)
			step.view.x += _key_axis(KEY_COMMA, KEY_PERIOD)
	
			step.view.x += mouse_move.x
			step.view.y += mouse_move.y
			
			if Input.is_key_pressed(KEY_SPACE):
				step.states[CookInputSet.Action.PRIMARY] = 1
			if Input.is_key_pressed(KEY_ALT):
				step.states[CookInputSet.Action.SECONDARY] = 1
			if Input.is_key_pressed(KEY_SHIFT):
				step.states[CookInputSet.Action.TRIGGER] = 1
			if Input.is_key_pressed(KEY_ENTER):
				step.states[CookInputSet.Action.START] = 1
			if Input.is_key_pressed(KEY_ESCAPE):
				step.states[CookInputSet.Action.BACK] = 1
			if Input.is_key_pressed(KEY_COMMA):
				step.states[CookInputSet.Action.BUMPER_L] = 1
			if Input.is_key_pressed(KEY_PERIOD):
				step.states[CookInputSet.Action.BUMPER_R] = 1
			if Input.is_key_pressed(KEY_C):
				step.states[CookInputSet.Action.VIEW_TOGGLE] = 1
		if i == 1 or (i == 0 and player_slot_count < 2):
			step.move.x += _key_axis(KEY_A, KEY_D)
			step.move.y += _key_axis(KEY_W, KEY_S)
			step.view.x += _key_axis(KEY_Q, KEY_E)
			
			if Input.is_key_pressed(KEY_R):
				step.states[CookInputSet.Action.PRIMARY] = 1
			if Input.is_key_pressed(KEY_R):
				step.states[CookInputSet.Action.SECONDARY] = 1
			if Input.is_key_pressed(KEY_SHIFT):
				step.states[CookInputSet.Action.TRIGGER] = 1
				
		if i < connected_joys.size():
			var jid := connected_joys[i]
			step.move.x += Input.get_joy_axis(jid, JOY_AXIS_LEFT_X)
			step.move.x += _bool_axis(Input.is_joy_button_pressed(jid, JOY_BUTTON_DPAD_LEFT), Input.is_joy_button_pressed(jid, JOY_BUTTON_DPAD_RIGHT))
			step.move.y += Input.get_joy_axis(jid, JOY_AXIS_LEFT_Y)
			step.move.y += _bool_axis(Input.is_joy_button_pressed(jid, JOY_BUTTON_DPAD_UP), Input.is_joy_button_pressed(jid, JOY_BUTTON_DPAD_DOWN))
			step.view.x += Input.get_joy_axis(jid, JOY_AXIS_RIGHT_X)
			step.view.y += Input.get_joy_axis(jid, JOY_AXIS_RIGHT_Y)
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_A) or Input.is_joy_button_pressed(jid, JOY_BUTTON_Y):
				step.states[CookInputSet.Action.PRIMARY] = 1
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_B) or Input.is_joy_button_pressed(jid, JOY_BUTTON_X):
				step.states[CookInputSet.Action.SECONDARY] = 1
			if Input.get_joy_axis(jid, JOY_AXIS_TRIGGER_RIGHT) > 0.0 or Input.get_joy_axis(jid, JOY_AXIS_TRIGGER_LEFT) > 0.0:
				step.states[CookInputSet.Action.TRIGGER] = 1
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_START):
				step.states[CookInputSet.Action.START] = 1
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_BACK):
				step.states[CookInputSet.Action.BACK] = 1
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_LEFT_SHOULDER):
				step.states[CookInputSet.Action.BUMPER_L] = 1
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_RIGHT_SHOULDER):
				step.states[CookInputSet.Action.BUMPER_R] = 1
			if Input.is_joy_button_pressed(jid, JOY_BUTTON_RIGHT_STICK):
				step.states[CookInputSet.Action.VIEW_TOGGLE] = 1
				
		step.move *= 1.3
		step.clamp()
			
		var is_moving = step.move.length_squared() > MOVE_TRIGGER_SQ
		var was_moving = prev_actions[CookInputSet.Action.MOVED] > 0
		if is_moving:
			if not was_moving or step.move.dot(prev_move) < 0.2:
				step.states[CookInputSet.Action.MOVED] = 2
			else:
				step.states[CookInputSet.Action.MOVED] = 1
		else:
			step.states[CookInputSet.Action.MOVED] = 0
			
		for act in range(CookInputSet.Action.MAX):
			if act == CookInputSet.Action.MOVED or act == CookInputSet.Action.VIEWED:
				continue
			var is_pressed = step.states[act] > 0
			var was_pressed = prev_actions[act] > 0
			if is_pressed:
				if not was_pressed:
					step.states[act] = 2
				else:
					step.states[act] = 1
			else:
				step.states[act] = 0
		
	mouse_delta = Vector2.ZERO
		
	all_input.reset()
	for step in sets:
		all_input.add(step)
	all_input.clamp()
	
	var applied_mouse_mode := mouse_mode
	if not has_focus:
		applied_mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	var is_maximized = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_MAXIMIZED
	if Input.is_key_pressed(KEY_ALT) and Input.is_key_pressed(KEY_ENTER):
		if is_maximized:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	if applied_mouse_mode != Input.mouse_mode:
		Input.mouse_mode = applied_mouse_mode
	is_capturing = Input.mouse_mode == mouse_mode_captured
	
	
func _ready() -> void:
	get_viewport().focus_entered.connect(_on_window_focus_in)
	get_viewport().focus_exited.connect(_on_window_focus_out)
	
	
func _on_window_focus_in() -> void:
	has_focus = true
	
	
func _on_window_focus_out() -> void:
	has_focus = false
	
	
func get_input(index: int) -> CookInputSet:
	if index < 0 or index >= sets.size():
		return blank_input
	return sets[index] as CookInputSet
	
	
func get_combined() -> CookInputSet:
	return all_input
	

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
		
	
func capture_mouse(capture := true) -> void:
	if capture == is_capturing:
		return
	is_capturing = capture
	if capture:
		mouse_mode = mouse_mode_captured
	else:
		mouse_mode = mouse_mode_uncaptured
	
	
static func _is_gamepad(jid: int) -> bool:
	if not Input.is_joy_known(jid):
		return false
	var jname := Input.get_joy_name(jid).to_lower()
	return not IGNORED_JOY_NAMES.any(func(word): return jname.contains(word))


static func _key_axis(negative: Key, positive: Key) -> float:
	return _bool_axis(Input.is_key_pressed(negative), Input.is_key_pressed(positive))
	
	
static func _bool_axis(negative: bool, positive: bool) -> float:
	var result = 0.0
	if positive:
		result += 1.0
	if negative:
		result -= 1.0
	return result
