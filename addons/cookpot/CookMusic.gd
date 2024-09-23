extends Node

@export var music_list: CookMusicList

var player: AudioStreamPlayer
var playing: CookMusicEntry

func play(name: String, restart := false) -> void:
	if music_list == null:
		printerr("CookMusicList must be added to CookMusic")
	var entry := music_list.get_entry(name)
	if entry == null:
		printerr("Can't find entry '%s'" % name)
	if player == null:
		player = AudioStreamPlayer.new()
		add_child(player)
	if playing != null and entry == playing:
		return
	playing = entry
	player.volume_db = linear_to_db(music_list.master_volume * playing.volume)
	player.stream = entry.file
	player.play()


func _process(delta: float) -> void:
	if playing == null:
		return
	if player.playing:
		var position = player.get_playback_position()
		var remaining = playing.loop_end - position
		player.volume_db = linear_to_db(music_list.master_volume * playing.volume)			
		if remaining < 0:
			player.seek(playing.loop_start + remaining)
