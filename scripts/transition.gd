extends CanvasLayer

var _modulate_tween: SceneTreeTween

func change_scene(p_destination: String) -> void:
	if is_instance_valid(_modulate_tween):
		_modulate_tween.stop()
		_modulate_tween.kill()
	
	_modulate_tween = create_tween()
	
	var __ = _modulate_tween.tween_property($ColorRect, "modulate:a", 1, 0.5)
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	_modulate_tween = create_tween()
	__ = _modulate_tween.tween_property($ColorRect, "modulate:a", 0, 0.5)
	__ = get_tree().change_scene(p_destination)
