class_name MusicManager extends Node
# TODO bare bones
var game_music
var menu_music

var sounds: Dictionary[String, AudioStreamPlayer]

func _init(sounds: Dictionary[String, AudioStreamPlayer]) -> void:
	self.sounds = sounds

func play_sound(sound_name: String):
	var sound: AudioStreamPlayer = sounds.get(sound_name) as AudioStreamPlayer
	if sound_name == "pellet":
		sound.pitch_scale = randf_range(0.9, 1.1)
	sound.play()
	
#func ease_music_in_and_out(music: AudioStreamPlayer, volume: int):
	#var tween = get_tree().create_tween()
	#tween.tween_property(music, "volume_db", volume, 1)
	#tween.tween_callback(stop_and_start_music.bind(music))
	#tween.tween_callback(reset_music_volume.bind(music))
#
#func stop_and_start_music(music: AudioStreamPlayer):
	#if music.name == "GameMusic":
		#game_music.stop()
		#menu_music.play()
	#else:
		#menu_music.stop()
		#game_music.play()
#
#func reset_music_volume(music: AudioStreamPlayer):
	#music.volume_db = 0
