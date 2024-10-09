extends Panel

var _label_tween: SceneTreeTween
var _picture_tween: SceneTreeTween
var __
var _picture_index: int = 0

onready var _game_image_texture: TextureRect = $CenterContainer/HBoxContainer/TextureRect
onready var _downloads_label: Label = $CenterContainer/HBoxContainer/VBoxContainer/HBoxContainer/CountMillionLabel


func _ready() -> void:
	WebsiteHelper.f_save(GlobalStore.GAME_PICTURES, "res://assets/Json/first_page.json")
	
	var m_json = WebsiteHelper.f_load("res://assets/Json/first_page.json")
	_game_image_texture.texture = load(m_json[_picture_index])
	
	_kill_tweens()
	_label_tween = create_tween()
	__ = _label_tween.tween_method(
		self,
		"set_label_text",
		0,
		116,
		2
	).set_ease(Tween.EASE_OUT)


func set_label_text(p_value) -> void:
	_downloads_label.text = str(p_value)


func _kill_tweens() -> void:
	if is_instance_valid(_picture_tween):
		_picture_tween.stop()
		_picture_tween.kill()
	
	if is_instance_valid(_label_tween):
		_label_tween.stop()
		_label_tween.kill()


func _on_TextureTimer_timeout() -> void:
	_picture_index += 1

	if _picture_index == GlobalStore.GAME_PICTURES.size():
		_picture_index = 0

	_change_game_image_texture(_picture_index)


func _change_game_image_texture(p_index: int) -> void:
	_kill_tweens()
	_picture_tween = create_tween().set_parallel(true)
	__ = _picture_tween.tween_property(
		_game_image_texture, 
		"modulate:a", 
		0, 
		0.25
	)
	__ = _picture_tween.tween_property(
		_game_image_texture, 
		"texture", 
		load(GlobalStore.GAME_PICTURES[p_index]) , 
		0.25
	)
	__ = _picture_tween.chain().tween_property(
		_game_image_texture, 
		"modulate:a", 
		1, 
		0.25
	)
