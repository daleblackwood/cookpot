extends Node3D

@export var gfx_list: CookGFXList

func fire(name: String, position: Vector3) -> Node3D:
	if gfx_list == null:
		printerr("No GFX List set")
		return null
	var inst = gfx_list.get_instance(name)
	if inst.get_parent() == null:
		add_child(inst)
	else:
		deactivate(inst)
	inst.global_transform.origin = position
	set_active(inst, true)
	if inst.has_method("_on_fire"):
		inst.call("_on_fire")
	return inst
	

func deactivate(node: Node3D) -> void:
	set_active(node, false)
	

func set_active(node: Node3D, active: bool) -> void:
	node.set_process(active)
	node.set_physics_process(active)
	node.set_process_input(active)
	node.visible = active
