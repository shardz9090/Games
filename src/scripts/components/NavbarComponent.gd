extends PanelContainer

const SCENE_NAMES: Array = [
	"Our Products",
	"About Us",
	"Journey",
	"Our Team",
	"Our Partners",
]

export(PackedScene) var link_buttons

onready var buttons_h_box: HBoxContainer = $MarginContainer/HBoxContainer/MarginContainer3/ButtonsHBox


func _ready() -> void:
	var m_link_buttons_instance: Object
	
	for i in range(SCENE_NAMES.size()):
		m_link_buttons_instance = link_buttons.instance()
		m_link_buttons_instance.initialize(i, SCENE_NAMES[i])
		buttons_h_box.add_child(m_link_buttons_instance)
	
