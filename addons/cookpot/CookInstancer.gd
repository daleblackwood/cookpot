class_name CookInstancer
extends Node

@export var instance_pool: CookInstancePool

func spawn(inst_name: String, parent: Node = null, position: Variant = null, method := "", data: Variant = null) -> Node3D:
	if instance_pool == null:
		printerr("No instance pool set")
		return null
	var inst = instance_pool.get_instance(inst_name)
	if inst == null:
		return null
	var last_parent := inst.get_parent()
	if last_parent and last_parent != parent:
		last_parent.remove_child(inst)
		last_parent = null
	if parent and last_parent != parent:
		parent.add_child(inst)
	if position:
		inst.position = position
	if method and not method.is_empty():
		if inst.has_method(method):
			if data == null:
				inst.call(method)
			else:
				inst.call(method, data)
	if inst is CPUParticles3D:
		(inst as CPUParticles3D).restart()
	return inst
	
