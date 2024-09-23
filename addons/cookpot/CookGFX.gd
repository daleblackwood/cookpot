extends Node3D

@export var gfx_list: CookGFXList

func fire(caller: Node3D, name: String, position: Vector3, direction := Vector3.ZERO) -> Node3D:
	if gfx_list == null:
		printerr("No GFX List set")
		return null
	var inst = gfx_list.get_instance(name)
	if inst.get_parent() == null:
		add_child(inst)
	inst.global_transform.origin = position
	if inst.has_method("_on_fire"):
		inst.call("_on_fire", caller, direction)
	return inst
