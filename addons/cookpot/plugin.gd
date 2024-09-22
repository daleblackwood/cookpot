@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("CookInput", "CookInput.tscn")
	add_autoload_singleton("CookSFX", "CookSFX.tscn")
	add_autoload_singleton("CookGFX", "CookGFX.tscn")
	
	
func _exit_tree() -> void:
	remove_autoload_singleton("CookInput")
	remove_autoload_singleton("CookSFX")
	remove_autoload_singleton("CookGFX")
