extends Control


onready var music_button: TextureButton = $CenterContainer/VBoxContainer/VBoxContainer/HBoxContainer/music_button
onready var sfx_button: TextureButton = $CenterContainer/VBoxContainer/VBoxContainer/HBoxContainer2/sfx_button
onready var sound_button: TextureButton = $CenterContainer/VBoxContainer/VBoxContainer/SoundHbox/sound_button
onready var _reset_popup: WindowDialog = $reset_popup


func _ready() -> void:
	if Global.is_music_on:
		music_button.change_button_state(true)
	else:
		music_button.change_button_state(false)
	
	if Global.is_sfx_on:
		sfx_button.change_button_state(true)
	else:
		sfx_button.change_button_state(false)
	
	if Global.is_sound_on:
		sound_button.change_button_state(true)
	else:
		sound_button.change_button_state(false)


func _on_music_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	music_button._on_TextureButton_pressed(Global.is_music_on)
	Global.change_music_state()


func _on_sfx_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	sfx_button._on_TextureButton_pressed(Global.is_sfx_on)
	Global.change_sfx_state()


func _on_sound_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	sound_button._on_TextureButton_pressed(Global.is_sound_on)
	Global.change_sound_state()


func _on_back_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	Transition.change_scene("res://Home.tscn")


func _on_TextureButton_pressed() -> void:
	_reset_popup.popup()
	
	if Global.is_sfx_on:
		SfxSound.play()
	
	var file = File.new()
	file.open("res://save_game.dat", File.WRITE)
	file.store_string("0")
	file.close()


func _on_ok_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	_reset_popup.hide()
