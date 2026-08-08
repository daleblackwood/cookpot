class_name CookResourcePool
extends Resource

@export var resources: Array[Resource]

func get_resource(name: String) -> Resource:
	var key := CookStrings.to_tag(name)
	for r in resources:
		if CookStrings.to_tag(r.resource_name) == key:
			return r
	return null

var _groups: Dictionary[StringName, Array] = {}
func get_group(name: String) -> Array[Resource]:
	var key := CookStrings.to_tag_numberless(name)
	if not _groups.has(key):
		var group: Array[Resource] = []
		for r in resources:
			if CookStrings.to_tag(r.resource_name) == key:
				group.append(r)
		_groups[key] = group
	return _groups[key]

var _picks: Dictionary[StringName, int] = {}
func pick(name: String, seed := 0) -> Resource:
	var key := CookStrings.to_tag_numberless(name)
	var group := get_group(key)
	if not group:
		return null
	var pick_index = seed if not _picks.has(key) else _picks[key]
	if seed == 0:
		pick_index += 1
	else:
		pick_index = CookMath.rnd(pick_index)
	_picks[key] = pick_index
	return group[pick_index % group.size()]
