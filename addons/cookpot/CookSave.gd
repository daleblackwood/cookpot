extends Node

signal value_set(key: String)

var slot := 0
var data := Dictionary()


func set_count(key: String, value: int, player := 0) -> void:
	var k = to_key(key, player)
	data[k] = max(value, 0)
	value_set.emit(k)
	
	
func increase_count(key: String, inc := 1, player := 0) -> void:
	var v = get_count(key, player)
	set_count(key, max(v + inc, 0), player)
	
	
func get_count(key: String, player := 0) -> int:
	var k = to_key(key, player)
	if not data.has(k):
		return 0
	return data[k] as int
	
	
func set_string(key: String, value: String, player := 0) -> void:
	var k = to_key(key, player)
	data[k] = value
	value_set.emit(k)
	
	
func set_value(key: String, value: String, player := 0) -> void:
	var k = to_key(key, player)
	var stored_value
	if value.is_valid_int():
		stored_value = value.to_int()
	elif value.is_valid_float():
		stored_value = value.to_float()
	elif value.to_lower() == "true":
		stored_value = true
	elif value.to_lower() == "false":
		stored_value = false
	else:
		stored_value = value
	data[k] = stored_value
	value_set.emit(k)
	
	
func get_string(key: String, player := 0) -> String:
	var k = to_key(key, player)
	if not data.has(k):
		return ""
	return data[k] as String
	
	
func set_float(key: String, value: float, player := 0) -> void:
	var k = to_key(key, player)
	data[k] = value
	value_set.emit(k)
	
	
func get_float(key: String, player := 0) -> float:
	var k = to_key(key, player)
	if not data.has(k):
		return 0
	return data[k] as float
	
	
func set_vector(key: String, value: Vector3, player := 0) -> void:
	var k = to_key(key, player)
	data[k] = [value.x, value.y, value.z]
	value_set.emit(k)
	
	
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
	clear()
	self.slot = slot
	data = read_file(slot)
	
	
func save() -> void:
	write_file(slot, data)
	
	
func clear() -> void:
	data.clear()
		
		
func read_file(slot: int) -> Dictionary:
	var filename := get_filename(slot)
	if not FileAccess.file_exists(filename):
		return Dictionary()
	var file := FileAccess.open(filename, FileAccess.READ)
	file.big_endian = true
	var size := file.get_32()
	var bytes := file.get_buffer(size)
	var expected_checksum := file.get_64()
	file.close()
	if hash(bytes) != expected_checksum:
		return Dictionary()
	var dict = bytes_to_var(bytes)
	if typeof(dict) != TYPE_DICTIONARY:
		return Dictionary()
	return dict as Dictionary


static func write_file(slot: int, dict: Dictionary) -> void:
	var filename := get_filename(slot)
	var file := FileAccess.open(filename, FileAccess.WRITE)
	file.big_endian = true
	var bytes := var_to_bytes(dict)
	file.store_32(bytes.size())
	file.store_buffer(bytes)
	file.store_64(hash(bytes))
	file.close()
	
	
static func remove_file(slot: int) -> void:
	var filename := get_filename(slot)
	if not FileAccess.file_exists(filename):
		return
	
		
static func get_filename(slot: int) -> String:
	return ("user://save%s.sav" % slot)
	
	
static func to_key(name: String, index: int) -> String:
	return CookStrings.to_tag(name) + str(index)
