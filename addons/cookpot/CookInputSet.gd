class_name CookInputSet
extends RefCounted

enum Action { PRIMARY, SECONDARY, TRIGGER, BUMPER_L, BUMPER_R, START, BACK, MOVED, VIEWED, VIEW_TOGGLE, OPTION, MAX }

var move := Vector2.ZERO
var view := Vector2.ZERO
var states := PackedByteArray()

func _init() -> void:
	states.resize(Action.MAX)
	reset()
	
func reset() -> void:
	move = Vector2.ZERO
	view = Vector2.ZERO
	states.fill(0)

func pressed(action: Action) -> bool:
	return states[action] >= 1

func fired(action: Action) -> bool:
	return states[action] == 2
	
func add(other: CookInputSet) -> void:
	move += other.move
	view += other.view
	for i in range(Action.MAX):
		if other.states[i] > states[i]:
			states[i] = other.states[i]
		
func clamp() -> void:
	if move.length_squared() > 1.0:
		move = move.normalized()
	if view.length_squared() > 1.0:
		view = view.normalized()
