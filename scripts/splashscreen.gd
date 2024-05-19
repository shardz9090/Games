extends Control


var _splash_tween: SceneTreeTween

onready var _progress_bar: ProgressBar = $ProgressBar


func _ready():
	_splash_tween = create_tween()
	var __ = _splash_tween.tween_property(_progress_bar, "value", 100, 3)


func _on_ProgressBar_value_changed(value):
	if value >= 100:
		Transition.change_scene("res://scenes/ui/mainmenu.tscn")
