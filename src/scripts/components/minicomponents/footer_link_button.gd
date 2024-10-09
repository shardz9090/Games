extends LinkButton

var button_link: String


func _ready() -> void:
	pass


func _on_LinkButton_pressed() -> void:
	OS.shell_open(button_link)
