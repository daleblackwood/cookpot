@tool
extends EditorPlugin

const DIR := "cooking"

func _enter_tree() -> void:
	_autoload_local_scene("CookInput", "CookInput.tscn")
	_autoload_local_scene("CookSFX", "CookSFX.tscn")
	_autoload_local_scene("CookInstancer", "CookInstancer.tscn")
	_autoload_local_scene("CookResourcer", "CookResourcer.tscn")
	_autoload_local_scene("CookMusic", "CookMusic.tscn")
	add_autoload_singleton("CookSave", "CookSave.gd")
	add_autoload_singleton("CookCaster", "CookCaster.gd")

func _exit_tree() -> void:
	remove_autoload_singleton("CookInput")
	remove_autoload_singleton("CookSFX")
	remove_autoload_singleton("CookInstancer")
	remove_autoload_singleton("CookResourcer")
	remove_autoload_singleton("CookMusic")
	remove_autoload_singleton("CookSave")
	remove_autoload_singleton("CookCaster")

func _autoload_local_scene(autoload_name: String, file_name: String) -> void:
	var dest_path := "res://" + DIR + "/".path_join(file_name)
	if not FileAccess.file_exists(dest_path):
		print("Creating Cook autoloader %s..." % dest_path)
		var dir := DirAccess.open("res://")
		if not dir.dir_exists(DIR):
			dir.make_dir(DIR)
		var source_path = get_script().resource_path.get_base_dir().path_join(file_name)
		DirAccess.copy_absolute(source_path, dest_path)
	add_autoload_singleton(autoload_name, dest_path)
