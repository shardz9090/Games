extends Panel


var _game_name: String
var _game_description: String
var _is_game_in_App_store: bool
var _is_game_in_Website: bool
var _is_game_in_play_store: bool

onready var h_box_container = $MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HBoxContainer
onready var scroll_container = $MarginContainer/VBoxContainer/MarginContainer/ScrollContainer


func _ready() -> void:
	WebsiteHelper.f_save(
		GlobalStore.PARTNERS_LOGOS, 
		"res://assets/Json/seventh_page.json"
	)
	var m_json = WebsiteHelper.f_load("res://assets/Json/seventh_page.json")
	_spawn_texture_in_hbox(m_json)


func _spawn_texture_in_hbox(p_json) -> void:
	var new_texture: TextureRect
	for i in range(p_json.size()):
		new_texture = TextureRect.new();
		new_texture.expand = true
		new_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		new_texture.rect_min_size = Vector2(150, 75)
		new_texture.texture = load(p_json[i]["logo"])
		h_box_container.add_child(new_texture)
