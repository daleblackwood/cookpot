class_name CookMusicList
extends Resource

@export var music: Array[CookMusicEntry]
@export_range(0.0, 1.0) var master_volume := 0.5

func get_entry(name: String) -> CookMusicEntry:
	var tag = CookStrings.to_tag(name)
	for entry in music:
		if entry.file == null:
			continue
		var entry_tag = CookStrings.to_tag(entry.file.resource_path)
		if entry_tag == tag:
			return entry
	return null
