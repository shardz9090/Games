extends TextureButton


var _is_button_in_right: bool = true
var _button_tween: SceneTreeTween
var _button_position_on_left: Vector2 = Vector2(0,2.731)
var _button_position_on_right: Vector2 = Vector2(77.264,2.731)
var _default_base_color: Color = Color(0.25,0.88,0.00,1.00)
var _slider_button_on_color: Color = Color(0.64,0.64,0.64,1)

onready var _slider_base = $SliderBase
onready var _slider_button = $SliderButton


func _on_TextureButton_pressed(p_is_on: bool) -> void:
	if is_instance_valid(_button_tween):
		_button_tween.stop()
		_button_tween.kill()
	
	_button_tween = create_tween()
	var __ = _button_tween.set_parallel(true)
	
	if p_is_on:
		__ = _button_tween.tween_property(_slider_button, "rect_position", _button_position_on_left, 0.5)
		__ = _button_tween.tween_property(_slider_button, "modulate", _slider_button_on_color, 0.5)
	else:
		__ = _button_tween.tween_property(_slider_button, "rect_position", _button_position_on_right, 0.5)
		__ = _button_tween.tween_property(_slider_button, "modulate", _default_base_color, 0.5)
	p_is_on = !p_is_on

func change_button_state(p_is_button_on: bool) -> void:
	if p_is_button_on:
		_slider_button.rect_position = _button_position_on_right
		_slider_button.modulate = _default_base_color
	else:
		_slider_button.rect_position = _button_position_on_left
		_slider_button.modulate = _slider_button_on_color
