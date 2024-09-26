class_name CookGFXList
extends Resource

@export var default_pool_size := 8
@export var scenes: Array[PackedScene] = []
@export var pool_size_overrides: Array[int] = []
@export var free_previous := true

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
	if free_previous and pool.instances[index] != null:
		pool.instances[index].queue_free()
		pool.instances[index] = null
	if pool.instances[index] == null:
		pool.instances[index] = pool.scene.instantiate()
	var inst = pool.instances[index]
	pool.next = (index + 1) % pool.size
	return inst
		
		
func get_pool(name: String) -> PoolEntry:
	var tag := CookStrings.to_tag(name)
	if not pools.has(name):
		var scene_index := -1
		for i in range(scenes.size()):
			var scene = scenes[i]
			if scene == null:
				continue
			var scene_tag = CookStrings.to_tag(scene.resource_path)
			if scene_tag == tag:
				scene_index = i
				break
		if scene_index < 0:
			printerr("No scene called %s" % name)
			return null
		var pool := PoolEntry.new()
		pool.scene = scenes[scene_index]
		pool.size = default_pool_size
		if scene_index < pool_size_overrides.size():
			var size_match = pool_size_overrides[scene_index]
			if size_match > 0:
				pool.size = size_match
		pool.instances.resize(pool.size)
		pool.instances.fill(null)
		pools[name] = pool
	return pools[name]
