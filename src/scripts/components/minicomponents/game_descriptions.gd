extends HBoxContainer

var _name: String
var _description: String
var _is_in_playstore: bool
var _is_in_appstore: bool
var _is_in_web: bool
var _image_path: String
var _logo_path: String

onready var _game_title: Label = $DetailsContainer/MarginContainer/VBoxContainer/HBoxContainer/GameTitle
onready var _game_logo: TextureRect = $DetailsContainer/MarginContainer/VBoxContainer/HBoxContainer/GameLogo
onready var _game_description: Label = $DetailsContainer/MarginContainer/VBoxContainer/GameDescription
onready var _play_store_button: TextureButton = $DetailsContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/PlayStoreButton
onready var _app_store_button: TextureButton = $DetailsContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/AppStoreButton
onready var _web_button: TextureButton = $DetailsContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/WebButton
onready var game_picture = $PictureContainer/GamePicture


func _ready() -> void:
	_game_title.text = _name
	_game_logo.texture = load(_logo_path)
	game_picture.texture = load(_image_path)
	_game_description.text = _description
	
	if _is_in_appstore:
		_app_store_button.show()
	else:
		_app_store_button.hide()
	if _is_in_playstore:
		_play_store_button.show()
	else:
		_play_store_button.hide()
	if _is_in_web:
		_web_button.show()
	else:
		_web_button.hide()


func initialize(
	p_name,
	p_description,
	p_is_in_playstore,
	p_is_in_appstore,
	p_is_in_web,
	p_image_path,
	p_logo_path
) -> void:
	_name = p_name
	_description = p_description
	_is_in_appstore = p_is_in_appstore
	_is_in_playstore = p_is_in_playstore
	_is_in_web = p_is_in_web
	_image_path = p_image_path
	_logo_path = p_logo_path
