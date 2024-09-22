class_name CookGFXList
extends Resource

@export var default_pool_size := 8
@export var scenes: Array[PackedScene] = []
@export var pool_sizes: Array[int] = []

class PoolEntry:
	var scene: PackedScene
	var instances: Array[Node3D]
	var size: int
	var next := 0

var pools := Dictionary()


func get_instance(name: String) -> Node3D:
	var pool := get_pool(name)
	if not pool:
		return null
	var index = pool.next % pool.size
	if pool.instances[index] == null:
		pool.instances[index] = pool.scene.instantiate()
	var inst = pool.instances[index]
	pool.next = (index + 1) % pool.size
	return inst
		
		
func get_pool(name: String) -> PoolEntry:
	var tag := name_to_tag(name)
	if not pools.has(name):
		var scene_index := -1
		for i in range(scenes.size()):
			var scene = scenes[i]
			var scene_tag = name_to_tag(scene.resource_path)
			if scene_tag == tag:
				scene_index = i
				break
		if scene_index < 0:
			printerr("No scene called %s" % name)
			return null
		var pool := PoolEntry.new()
		pool.scene = scenes[scene_index]
		pool.size = default_pool_size
		if scene_index < pool_sizes.size():
			var size_match = pool_sizes[scene_index]
			if size_match > 0:
				pool.size = size_match
		pool.instances.resize(pool.size)
		pool.instances.fill(null)
		pools[name] = pool
	return pools[name]
		
		
static func name_to_tag(name: String) -> String:
	var start = name.rfindn("/") + 1
	var end = name.length()
	var last_dot = name.rfindn(".")
	if last_dot > 0 and last_dot > start:
		end = last_dot
	var result = ""
	for i in range(start, end):
		var c = name[i].to_lower()
		if (c < '0' or c > '9') and (c < 'a' or c > 'z'):
			continue
		result += c
	return result
		
