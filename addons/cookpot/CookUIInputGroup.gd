extends Control

var buttons: Array[Button]
var focused: Button
var input := Vector2.ZERO
var accepted := false


func _ready() -> void:
	buttons = find_buttons(self)
	set_focused(buttons[0])
	
	
func find_buttons(parent: Node) -> Array[Button]:
	var result: Array[Button] = []
	for i in range(get_child_count()):
		var child = get_child(i)
		if child is Button:
			result.append(child)
		else:
			var subchildren = find_buttons(child)
			if subchildren.size() > 0:
				result.append_array(subchildren)
	return result
	
	
func set_focused(button: Button) -> void:
	self.focused = button
	button.grab_focus()
	
	
func move_focus(from: Button, move: Vector2) -> void:
	if move == Vector2.ZERO:
		return
	var move_dir = move.normalized()
	var closest: Button = null
	var closest_sq = INF
	for button in buttons:
		var diff = button.global_position - from.global_position
		var dir = diff.normalized()
		var dot = dir.dot(move_dir)
		if dot < 0.5:
			continue
		var dist_sq = diff.length_squared()
		if dist_sq > closest_sq:
			continue
		closest = button
		closest_sq = dist_sq
	if closest != null:
		set_focused(closest)


func _process(delta: float) -> void:
	var was_input := input
	var was_accepted := accepted
	input = Vector2.ZERO
	accepted = false
	for i in CookInput.player_count:
		var player = CookInput.get_input(i)
		input += player.move
		if player.primary:
			accepted = true
	if accepted and not was_accepted:
		focused.pressed.emit()
	if input != Vector2.ZERO and was_input == Vector2.ZERO:
		move_focus(focused, input)
