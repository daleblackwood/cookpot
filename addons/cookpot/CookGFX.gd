extends Node3D

@export var gfx_list: CookGFXList


func fire(name: String, position: Vector3, data: Variant = null) -> Node3D:
	if gfx_list == null:
		printerr("No GFX List set")
		return null
	var inst = gfx_list.get_instance(name)
	if inst.get_parent() == null:
		add_child(inst)
	inst.global_transform.origin = position
	if inst.has_method("_on_fire"):
		if data == null:
			inst.call("_on_fire")
		else:
			inst.call("_on_fire", data)
	return inst
	

func fire_many(count: int, name: String, position: Vector3, data: Variant = null) -> Array[Node3D]:
	var result: Array[Node3D] = []
	for i in range(count):
		result.append(fire(name, position, data))
	return result
	
	
func fire_body(name: String, position: Vector3, spread: float, height := INF, data: Variant = null) -> RigidBody3D:
	if is_inf(height):
		height = spread
	var body := fire(name, position, data) as RigidBody3D
	var impulse = Vector3(randf_range(-spread, spread), height, randf_range(-spread, spread))
	body.apply_impulse(impulse)
	return body
	
	
func fire_bodies(count: int, name: String, position: Vector3, spread: float, height := INF, data: Variant = null) -> Array[RigidBody3D]:
	var result: Array[RigidBody3D] = []
	for i in range(count):
		result.append(fire_body(name, position, spread, height, data))
	return result	
