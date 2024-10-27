extends Control

var buttons: Array[Button]
var focused: Button
var initial_focus_delay := 1.0
var focus_delay := 0.0

func _ready() -> void:
	buttons = find_buttons(self)
	focus_delay = initial_focus_delay	
	
	
func grab_focus() -> void:
	focused = null
	set_focused(buttons[0])
	
	
func find_buttons(parent: Node) -> Array[Button]:
	var result: Array[Button] = []
	for i in range(parent.get_child_count()):
		var child = parent.get_child(i)
		if child is Button:
			result.append(child)
		else:
			var subchildren = find_buttons(child)
			if subchildren.size() > 0:
				result.append_array(subchildren)
	return result
	
	
func set_focused(button: Button) -> void:
	if self.focused == button:
		return
	self.focused = button
	button.grab_focus()
	CookSFX.play("ui-select")
	
	
func move_focus(from: Button, move: Vector2) -> void:
	if move == Vector2.ZERO:
		return
	var move_dir = move.normalized()
	var closest: Button = null
	var closest_sq = INF
	for button in buttons:
		if button == from:
			continue
		var diff = button.global_position - from.global_position
		var dir = diff.normalized()
		var dot = dir.dot(move_dir)
		if dot < 0.7:
			continue
		var dist_sq = diff.length_squared() * dot
		if dist_sq > closest_sq:
			continue
		closest = button
		closest_sq = dist_sq
	if closest != null:
		set_focused(closest)
		CookSFX.play("ui-select")


func _process(delta: float) -> void:
	if visible == false:
		return
		
	if focus_delay > 0.0:
		focus_delay -= delta
		if focus_delay < 0.0:
			set_focused(buttons[0])
		else:
			return
			
	var move := Vector2.ZERO
	var accepted = false
	for i in CookInput.player_count:
		var player = CookInput.get_input(i)
		if player.primary_fired:
			accepted = true
		if player.move_fired:
			move += player.move
			break
	if accepted:
		focused.pressed.emit()
	if move.length_squared() > 0.2:
		move_focus(focused, move)
