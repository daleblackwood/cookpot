@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("CookSFX", "CookSFX.tscn")
	add_autoload_singleton("CookInput", "CookInput.tscn")
	
	
func _exit_tree() -> void:
	remove_autoload_singleton("CookSFX")
