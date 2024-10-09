extends LinkButton

var button_index: int
var _text: String
var _link


func _ready() -> void:
	text = _text


func initialize(p_index: int, p_button_name: String) -> void:
	button_index = p_index
	_text = p_button_name


func _on_LinkButton_pressed() -> void:
	Events.emit_signal("redirect", button_index)
