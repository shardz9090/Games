extends TextureButton


signal key_pressed(data)

var is_flipped: bool = false
var button_number: int

var _button_tween: SceneTreeTween
var _original_button_size:= Vector2(1.162,1.071)
var _text_to_display: int = 0

onready var _button_color: ColorRect = $ColorRect
onready var _button_label: Label = $Label


func _ready() -> void:
	_kill_button_tween()


func _process(_delta) -> void:
	if is_flipped:
		_button_label.text = "?"
		_button_color.color = Color(1,1,0,1)
	else:
		_button_label.text = str(_text_to_display)
		_button_color.color = Color(0,1,0,1)


func _kill_button_tween() -> void:
	if is_instance_valid(_button_tween):
		_button_tween.stop()
		_button_tween.kill()


func _on_TextureButton_pressed() -> void:
	is_flipped = false
	
	if Global.is_sfx_on:
		SfxSound.play()

	_kill_button_tween()
	
	_button_tween = create_tween()
	var __ = _button_tween.tween_property(self, "rect_scale:x", 0, 0.1)
	__ = _button_tween.set_parallel(true)
	__ = _button_tween.chain().tween_property(self, "rect_scale", _original_button_size, 0.1)
	__ = _button_tween.tween_property(_button_color, "color",Color(0,1,0,1), 0)
	
	self.disabled = true
	
	emit_signal("key_pressed", button_number)


func set_button_disabled(p_disabled: bool) -> void:
	self.disabled = p_disabled
