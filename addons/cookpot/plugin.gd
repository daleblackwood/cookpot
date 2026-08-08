@tool
extends EditorPlugin

const DIR := "cooking"

func _enter_tree() -> void:
	_autoload_as_scene("CookInput", "CookInput.gd")
	_autoload_as_scene("CookSFX", "CookSFX.gd")
	_autoload_as_scene("CookGFX", "CookGFX.gd")
	_autoload_as_scene("CookResources", "CookResources.gd")
	_autoload_as_scene("CookMusic", "CookMusic.gd")
	add_autoload_singleton("CookSave", "CookSave.gd")
	add_autoload_singleton("CookCaster", "CookCaster.gd")
	EditorInterface.get_resource_filesystem().scan()
	EditorInterface.get_resource_filesystem().scan_sources()


func _exit_tree() -> void:
	remove_autoload_singleton("CookInput")
	remove_autoload_singleton("CookSFX")
	remove_autoload_singleton("CookGFX")
	remove_autoload_singleton("CookResources")
	remove_autoload_singleton("CookMusic")
	remove_autoload_singleton("CookSave")
	remove_autoload_singleton("CookCaster")
	

func _autoload_as_scene(autoload_name: String, script_src: String) -> void:
	var dir := DirAccess.open("res://")
	if not dir.dir_exists(DIR):
		dir.make_dir(DIR)

	var script_path := String(get_script().resource_path).get_base_dir().path_join(script_src)
	var dest_path := "res://".path_join(DIR).path_join(script_src.get_basename() + ".tscn")

	if not FileAccess.file_exists(dest_path):
		var tscn_content := "[gd_scene load_steps=2 format=3]\n\n[ext_resource type=\"Script\" path=\"%s\" id=\"1_script\"]\n\n[node name=\"%s\" type=\"Node\"]\nscript = ExtResource(\"1_script\")\n" % [script_path, autoload_name]
		var file := FileAccess.open(dest_path, FileAccess.WRITE)
		if file:
			file.store_string(tscn_content)
			file.close()

	add_autoload_singleton(autoload_name, dest_path)
