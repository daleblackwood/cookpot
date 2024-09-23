class_name CookMusicEntry
extends Resource

@export var file: AudioStream
@export var loop_start := 0.0
@export var loop_end := 0.0
@export_range(0.0, 1.0) var volume := 1.0
