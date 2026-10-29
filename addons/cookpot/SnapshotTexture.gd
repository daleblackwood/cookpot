@tool
class_name SnapshotTexture
extends ImageTexture

@export var resolution := 128
@export_range(1, 8) var supersample := 4
@export var padding := 0
@export var unshaded := false


func is_empty() -> bool:
	return get_width() == 0
