extends Node


var is_music_on: bool = true
var is_sfx_on: bool = true
var is_sound_on: bool = true
var level: String
var high_score: int


func change_sfx_state() -> void:
	is_sfx_on = not is_sfx_on


func change_music_state() -> void:
	is_music_on = not is_music_on
	
	if not is_music_on:
		GameMusic.stop()
	else:
		GameMusic.play()


func change_sound_state() -> void:
	is_sound_on = not is_sound_on
