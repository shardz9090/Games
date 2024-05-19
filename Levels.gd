extends Control


onready var _about_level_popup: WindowDialog = $about_level
onready var _about_level_label: Label = $about_level/Label2
onready var _about_level_color: ColorRect = $about_level/ColorRect


func _on_back_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	Transition.change_scene("Home.tscn")


func _on_easy_button_pressed() -> void:
	_about_level_popup.popup()
	_about_level_label.text = "In this level there will be no time limit as soon as you press the first button all other will be flipped."
	_about_level_color.color = Color(0.17,0.64,0.20,1)
	
	if Global.is_sfx_on:
		SfxSound.play()
		
	Global.level = "easy"


func _on_medium_button_pressed() -> void:
	_about_level_popup.popup()
	_about_level_label.text = "In this level there will be timer at first of 1 second to see the positions of the card and then they will be flipped."
	_about_level_color.color = Color(0.64,0.62,0.17,1)
	
	if Global.is_sfx_on:
		SfxSound.play()
		
	Global.level = "medium"


func _on_hard__button_pressed() -> void:
	_about_level_popup.popup()	
	_about_level_label.text = "In this level there will be time limit for every button to be pressed."
	_about_level_color.color = Color(0.64,0.17,0.17,1)
	
	if Global.is_sfx_on:
		SfxSound.play()
		
	Global.level = "hard"


func _on_Button_pressed() -> void:
	Transition.change_scene("res://gamescene.tscn")
