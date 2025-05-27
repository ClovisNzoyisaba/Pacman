class_name MusicManager extends Node
# TODO bare bones
var game_music
var menu_music

func _init() -> void:
	pass # TODO pass references to game_music and or menu music here

func ease_music_in_and_out(music: AudioStreamPlayer, volume: int):
	var tween = get_tree().create_tween()
	tween.tween_property(music, "volume_db", volume, 1)
	tween.tween_callback(stop_and_start_music.bind(music))
	tween.tween_callback(reset_music_volume.bind(music))

func stop_and_start_music(music: AudioStreamPlayer):
	if music.name == "GameMusic":
		game_music.stop()
		menu_music.play()
	else:
		menu_music.stop()
		game_music.play()

func reset_music_volume(music: AudioStreamPlayer):
	music.volume_db = 0
