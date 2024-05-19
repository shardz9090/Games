extends CenterContainer

var score: int = 0
onready var _score_label: Label = $VBoxContainer/HBoxContainer/score


func _process(_delta) -> void:
	_score_label.text = str(score)


func _on_restart_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	Transition.change_scene("res://gamescene.tscn")


func _on_Level_change_button_pressed() -> void:
	Transition.change_scene("res://Levels.tscn")
