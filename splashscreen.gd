extends Control

var _progressbar_tween: SceneTreeTween

onready var _progressbar: ProgressBar = $ProgressBar
onready var _progress_value: ProgressBar = $ProgressBar


func _ready() -> void:
	randomize()
	
	_progressbar_tween = create_tween()
	var __ = _progressbar_tween.tween_property(_progress_value, "value", 100, 3)


func _on_ProgressBar_value_changed(p_value: float) -> void:
	if p_value >= 100:
		_progressbar.hide()
		var __ = Transition.change_scene("Home.tscn")
