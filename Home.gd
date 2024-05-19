extends CenterContainer


onready var _exit_popup: WindowDialog = $ConfirmationDialog
onready var _high_score_label: Label = $VBoxContainer/high_score


func _ready() -> void:
	var file: File = File.new()
	file.open("res://save_game.dat", File.READ)
	var m_content = file.get_as_text()
	file.close()
	
	Global.high_score = m_content
	_high_score_label.text = "high score = " + str(Global.high_score)


func _on_play_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	Transition.change_scene("Levels.tscn")


func _on_exit_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	_exit_popup.popup()


func _on_settings_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	Transition.change_scene("res://settings.tscn")


func _on_Exit_Yes_button_pressed() -> void:
	get_tree().quit()


func _on_Exit_No_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	_exit_popup.hide()
