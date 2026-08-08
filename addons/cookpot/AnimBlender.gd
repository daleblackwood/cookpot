class_name AnimBlender

class AnimBlendGroup:
	var tree: AnimationTree
	var blend_key: String
	var blend_enabled := false
	var blend_ease := 0.2
	var move_key: String
	var move_enabled := false
	var move_multi = 1.0
	var speed_key: String
	var speed_enabled := false
	var speed_multi = 1.0
	var blend := 0.0
	
	func _init(_tree: AnimationTree, key: String) -> void:
		tree = _tree
		blend_key = "parameters/%s_blend/blend_amount" % key
		blend_enabled = tree.get(blend_key) != null
		move_key = "parameters/%s_move/blend_amount" % key
		move_enabled = tree.get(move_key) != null
		speed_key = "parameters/%s_speed/scale" % key
		speed_enabled = tree.get(speed_key) != null
		
var tree: AnimationTree
var groups: Array[AnimBlendGroup] = []
		
func _init(_tree: AnimationTree, keys: Array) -> void:
	tree = _tree
	groups.resize(keys.size())
	for i in range(keys.size()):
		groups[i] = AnimBlendGroup.new(tree, String(keys[i]).to_lower())
		print("Added blend group: %s" % groups[i].blend_key)
		
		
func group(index: int) -> AnimBlendGroup:
	if index < 0 or index >= groups.size():
		return null
	return groups[index]
	
	
func apply(dt: float, move_state: int, move_speed: float) -> void:
	for i in range(groups.size()):
		var group = groups[i]
		var active = i == move_state
		if group.blend_enabled:
			group.blend = lerpf(group.blend, 1.0 if active else 0.0, CookMath.dease(dt, group.blend_ease))
			tree.set(group.blend_key, group.blend)
		if group.move_enabled:
			tree.set(group.move_key, clampf(move_speed * group.move_multi, 0.0, 1.0))
		if group.speed_enabled:
			tree.set(group.speed_key, move_speed * group.speed_multi)
			
			
func one_shot(key: String) -> void:
	tree.set("parameters/%s/request" % key, 1)
	
		
