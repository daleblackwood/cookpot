@tool
class_name CookSFXList
extends Resource

const allowed_types := ["wav", "mp3", "ogg"]

@export var audio_files: Array[AudioStream] = []

@export_file var import_folder: String:
	set(value):
		_import_folder(value)
		import_folder = value
		
		
func _import_folder(path: String) -> void:
	if not Engine.is_editor_hint():
		return
	var new_audio_files := audio_files.duplicate(false)
	var folder_name = path.substr(0, path.rfindn("/"))
	for file in DirAccess.get_files_at(folder_name):
		var ext = file.substr(file.rfindn(".") + 1).to_lower()
		if allowed_types.find(ext) < 0:
			continue
		var found := false
		var file_path = folder_name + "/" + file
		print("Added ", file_path)
		for i in range(audio_files.size()):
			if audio_files[i] == null:
				continue
			if audio_files[i].resource_path == file_path:
				found = true
				break
		if found:
			continue
		var audio_resource = load(file_path)
		if audio_resource is AudioStream:
			new_audio_files.append(audio_resource)
	audio_files = new_audio_files
	print("Close and reopen the Audio Files array")
	emit_changed()
