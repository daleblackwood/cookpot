class_name CookRecorder

const INTERVAL := 0.2

class Snapshot:
	var time := 0.0
	var position := Vector3.ZERO
	var score := 0
	
var snapshots: Array[Snapshot] = []


func clear() -> void:
	snapshots.clear()
	
	
func record(time: float, position: Vector3, score: int) -> void:
	var snapshot := Snapshot.new()
	snapshot.time = time
	snapshot.position = position
	snapshot.score = score
	var replace := false
	var last := snapshots.back()
	if last != null:
		var before := floorf(time / INTERVAL) * INTERVAL
		if last.time > before:
			replace = true
	if replace:
		snapshots[snapshots.size() - 1] = snapshot
	else:
		snapshots.append(snapshot)
		
		
func retrieve(time: float) -> Snapshot:
	var index = max(floor(time / INTERVAL) - 1, 0)
	var snapshot_count = snapshots.size()
	if snapshot_count == 1:
		return snapshots[1]
	if snapshot_count > 0:
		while index < snapshot_count and snapshots[index].time < time:
			index += 1
	if index < 0:
		return Snapshot.new()
	if index >= snapshot_count:
		return snapshots[snapshots.size() - 1]
	var before = snapshots[max(index - 1, 0)]
	var after = snapshots[index]
	var gap = after.time - before.time
	var elapsed = time - before.time
	var pc = elapsed / gap
	var snapshot := Snapshot.new()
	snapshot.time = time
	snapshot.position = before.position.lerp(after.position, pc)
	snapshot.score = floor(lerpf(before.score, after.score, pc))
	return snapshot

	
func save(path: String = "") -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	for snapshot in snapshots:
		file.store_float(snapshot.time)
		file.store_float(snapshot.position.x)
		file.store_float(snapshot.position.y)
		file.store_float(snapshot.position.z)
		file.store_16(snapshot.score)
	file.close()
	
	
func load(path: String = "") -> void:
	snapshots.clear()
	if not FileAccess.file_exists(path):
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var filesize = file.get_length()
	while file.get_position() < filesize:
		var snapshot := Snapshot.new()
		snapshot.time = file.get_float()
		snapshot.position.x = file.get_float()
		snapshot.position.y = file.get_float()
		snapshot.position.z = file.get_float()
		snapshot.score = file.get_16()
		snapshots.append(snapshot)
	file.close()
