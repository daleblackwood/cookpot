extends Node

var slot := 0
var data := Dictionary()


func set_count(key: String, value: int, player := 0) -> void:
	var k = to_key(key, player)
	data[k] = value
	
	
func increase_count(key: String, inc := 1, player := 0) -> void:
	var v = get_count(key, player)
	set_count(key, v + inc, player)
	
	
func get_count(key: String, player := 0) -> int:
	var k = to_key(key, player)
	if not data.has(k):
		return 0
	return data[k] as int
	
	
func set_string(key: String, value: String, player := 0) -> void:
	var dkey = to_key(key, player)
	data[dkey] = value
	
	
func get_string(key: String, player := 0) -> String:
	var k = to_key(key, player)
	if not data.has(k):
		return ""
	return data[k] as String
	
	
func set_float(key: String, value: float, player := 0) -> void:
	var k = to_key(key, player)
	data[k] = value
	
	
func get_float(key: String, player := 0) -> float:
	var k = to_key(key, player)
	if not data.has(k):
		return 0
	return data[k] as float
	
	
func set_vector(key: String, value: Vector3, player := 0) -> void:
	var k = to_key(key, player)
	data[k] = [value.x, value.y, value.z]
	
	
func get_vector(key: String, player := 0) -> Vector3:
	var k = to_key(key, player)
	if not data.has(k):
		return Vector3.ZERO
	var v = data[k]
	return Vector3(v[0], v[1], v[2])
	
	
func has(key: String, player := 0) -> void:
	var k = to_key(key, player)
	return data.has(k)
	
	
func delete(slot: int) -> void:
	remove_file(slot)
	
	
func load(slot: int) -> void:
	self.slot = slot
	data = read_file(slot)
	
	
func save() -> void:
	write_file(slot, data)
		
		
func read_file(slot: int) -> Dictionary:
	var filename := get_filename(slot)
	if not FileAccess.file_exists(filename):
		return Dictionary()
	var file := FileAccess.open(filename, FileAccess.READ)
	var text := file.get_as_text(true)
	file.close()
	var dict := JSON.parse_string(text) as Dictionary
	return dict
	
	
static func write_file(slot: int, dict: Dictionary) -> void:
	var filename := get_filename(slot)
	var text := JSON.stringify(dict)
	var file := FileAccess.open("user://savegame.save", FileAccess.WRITE)
	file.store_string(text)
	file.close()
	
	
static func remove_file(slot: int) -> void:
	var filename := get_filename(slot)
	if not FileAccess.file_exists(filename):
		return
	
		
static func get_filename(slot: int) -> String:
	return ("user://save%s.save" % slot)
	
	
static func to_key(name: String, index: int) -> String:
	return CookStrings.to_tag(name) + str(index)
