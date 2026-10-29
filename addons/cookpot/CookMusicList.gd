class_name CookMusicList
extends Resource

@export_range(0.0, 1.0) var master_volume := 0.5
@export var music: Array[CookMusicEntry]

func get_entry(name: String) -> CookMusicEntry:
	for entry in music:
		if entry.file == null:
			continue
		if CookStrings.tag_match(name, entry.file.resource_path):
			return entry
	return null
