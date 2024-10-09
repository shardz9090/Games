extends PanelContainer

export(PackedScene) var h_box_for_journey

onready var _spawn_v_box_container = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer


func _ready() -> void:
	var m_h_box_instance: Object
#	WebsiteHelper.f_save(
#		GlobalStore.ACHIEVEMENT_DATES,
#		"res://assets/Json/fifth_page.json"
#	)
	var m_json = WebsiteHelper.f_load("res://assets/Json/fifth_page.json")
	var m_achieve_event: Dictionary
	
	for i in range(m_json.size()):
		m_achieve_event = m_json[i]

		m_h_box_instance = h_box_for_journey.instance()
		m_h_box_instance.initialize(
			i, 
			"res://assets/images/logos/callbreak_logo.webp",
			"2021/09/19",
			"Released Callbreak"
		)
		_spawn_v_box_container.add_child(m_h_box_instance)
