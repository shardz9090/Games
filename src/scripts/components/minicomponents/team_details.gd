extends VBoxContainer

var _name: String
var _post: String

onready var name_label = $NameLabel
onready var post_label = $PostLabel


func _ready() -> void:
	name_label.text = _name
	post_label.text = _post


func initialize(p_name: String, p_post: String) -> void:
	_name = p_name
	_post = p_post
