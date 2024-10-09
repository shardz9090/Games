extends PanelContainer

export(PackedScene) var member_details

onready var _team_grid_container = $MarginContainer/VBoxContainer/TeamGridContainer


func _ready() -> void:
	var m_json = WebsiteHelper.f_load("res://assets/Json/sixth_page.json")
	_spawn_members_details(m_json)


func _spawn_members_details(p_json: Array) -> void:
	var m_emp: Object
	var m_emp_details: Dictionary
	
	for i in range(p_json.size()):
		m_emp = member_details.instance()
		m_emp_details = p_json[i]
		m_emp.initialize(m_emp_details["name"], m_emp_details["post"])
		_team_grid_container.add_child(m_emp)
