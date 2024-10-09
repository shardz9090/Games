extends HBoxContainer

export(PackedScene) var achieve_date
export(PackedScene) var placeholder
export(PackedScene) var divider

var _index: int
var _achievement_box: Object


func _ready() -> void:
	if _index % 2 == 0:
		add_child(placeholder.instance())
		add_child(divider.instance())
		add_child(_achievement_box)
	else:
		add_child(_achievement_box)
		add_child(divider.instance())
		add_child(placeholder.instance())


func initialize(
	p_index: int, 
	p_image_path: String, 
	p_date: String, 
	p_achievement: String
) -> void:
	_index = p_index
	_achievement_box = achieve_date.instance()
	if _index % 2 == 0:
		_achievement_box.initialize(p_image_path, p_date, p_achievement, GlobalStore.Side.LEFT)
	else:
		_achievement_box.initialize(p_image_path, p_date, p_achievement, GlobalStore.Side.RIGHT)
