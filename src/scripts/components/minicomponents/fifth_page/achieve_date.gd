extends MarginContainer


var _date: String
var _achievement: String
var _index: int

onready var _date_label: Label = $Panel/CenterContainer/VBoxContainer/DateLabel
onready var _achieve_label: Label = $Panel/CenterContainer/VBoxContainer/AchieveLabel
onready var _right_triangle: TextureRect = $Panel/RightTriangle
onready var _left_triangle: TextureRect = $Panel/LeftTriangle

func _ready() -> void:
	_date_label.text = _date
	_achieve_label.text = _achievement
	if _index == GlobalStore.Side.LEFT:
		_right_triangle.hide()
	else:
		_left_triangle.hide()


func initialize(p_image_path: String, p_date: String, p_achievement: String, p_side: int) -> void:
	_index = p_side
	_date = p_date
	_achievement = p_achievement
