extends Node3D

const NO_SOURCE := Vector3.ZERO#Vector3(1234567890, 1234567890, 1234567890)

class AudioGroup:
	var name : String
	var index := 0
	var files: Array[AudioStream] = []
	func _init(name: String) -> void:
		self.name = name

@export var sfx_list: CookSFXList

const channel_count := 16

var groups := Dictionary()
var channel_index := 0
var channels: Array[AudioStreamPlayer3D] = []


func _init() -> void:
	for i in range(channel_count):
		var channel = AudioStreamPlayer3D.new()
		channel.name = "Audio Channel %s" % (i + 1)
		add_child(channel)
		channels.append(channel)


func play(sound_name: String, position: Vector3 = NO_SOURCE, volume := 1.0, index := -1) -> void:
	var file := get_file(sound_name, index)
	var channel := get_next_channel()
	if is_nan(position.x + position.y + position.z):
		var cam = get_tree().root.get_camera_3d()
		if cam != null:
			position =  cam.global_transform.origin
	channel.global_transform.origin = position
	channel.stream = file
	channel.volume_db = volume
	channel.play()
	
	
func get_next_channel() -> AudioStreamPlayer3D:
	var channel = channels[channel_index]
	channel_index = (channel_index + 1) % channel_count
	return channel
		
		
func get_file(sound_name: String, index := -1) -> AudioStream:
	if sfx_list == null or sfx_list.audio_files.size() < 1:
		return null
	var tag := CookStrings.to_tag(sound_name, false)
	if groups.has(tag) == false:
		var new_group = AudioGroup.new(tag)
		for file in sfx_list.audio_files:
			var ft := CookStrings.to_tag(file.resource_path, false)
			if ft == tag:
				new_group.files.append(file)
		if new_group.files.size() < 1:
			printerr("Can't find sound %s" % sound_name)
		groups[tag] = new_group
	var group: AudioGroup = groups[tag]
	if group.files.size() < 1:
		return
	if index < 0:
		index = randi() % group.files.size()
	else:
		index = index % group.files.size()
	var file := group.files[index]
	group.index = (index + 1) % group.files.size()
	return file
