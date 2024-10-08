@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("CookInput", "CookInput.tscn")
	add_autoload_singleton("CookSFX", "CookSFX.tscn")
	add_autoload_singleton("CookGFX", "CookGFX.tscn")
	add_autoload_singleton("CookMusic", "CookMusic.tscn")
	add_autoload_singleton("CookSave", "CookSave.gd")
	
	
func _exit_tree() -> void:
	remove_autoload_singleton("CookInput")
	remove_autoload_singleton("CookSFX")
	remove_autoload_singleton("CookGFX")
	remove_autoload_singleton("CookMusic")
	remove_autoload_singleton("CookSave")
