extends PanelContainer

export(PackedScene) var game_description

onready var v_box_container = $MarginContainer/VBoxContainer/MarginContainer/VBoxContainer

func _ready() -> void:
#	WebsiteHelper.f_save(GlobalStore.GAME_NAMES, "res://assets/Json/second_page.json")
	var m_json = WebsiteHelper.f_load("res://assets/Json/second_page.json")
	
	for i in range(m_json.size()):
		GlobalStore.game_names.append(
			{
				"Name" : m_json[i]["Name"],
				"Link" : m_json[i]["Link"]
			}
		)
	_spawn_product_details(m_json)


func _spawn_product_details(p_json: Array) -> void:
	for i in range(p_json.size()):
		
		var m_game_description_instance: Object = game_description.instance()
		m_game_description_instance.initialize(
			p_json[i]["Name"],
			p_json[i]["Description"],
			p_json[i]["PlayStore"],
			p_json[i]["AppStore"],
			p_json[i]["Website"],
			p_json[i]["Image"],
			p_json[i]["Logo"]
		)
		v_box_container.add_child(m_game_description_instance)
