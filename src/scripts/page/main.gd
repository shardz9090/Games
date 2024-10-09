extends Control

var __
var _scroll_tween: SceneTreeTween
var _navbar_tween: SceneTreeTween
var _scene_y_size_array: Array
var _is_navbar_hidden: bool
var _is_navbar_visible: bool

onready var _scroll_container: ScrollContainer = $ScrollContainer
onready var _v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer
onready var _navbar_panel: PanelContainer = $NavbarPanel

func _ready() -> void:
	Events.connect("redirect", self, "scroll_to_scene")
	
	var m_scene_array = _v_box_container.get_children()
	for i in range(m_scene_array.size()):
		_scene_y_size_array.append(m_scene_array[i].rect_size.y)


func scroll_to_scene(page_index) -> void:
	var m_scroll_height = 0
	
	for i in range(page_index+1):
		m_scroll_height += _scene_y_size_array[i]
	kill_tween(_scroll_tween)
	_scroll_tween = create_tween()
	__ = _scroll_tween.tween_property(
		_scroll_container,
		"scroll_vertical",
		m_scroll_height-157,
		0.5
	).set_ease(Tween.EASE_IN)


func kill_tween(p_tween) -> void:
	if is_instance_valid(p_tween):
		p_tween.stop()
		p_tween.kill()


func _process(delta) -> void:
	if not _is_navbar_hidden and _scroll_container.scroll_vertical <= 700:
		toggle_navbar_position(Vector2(0,-157))
		_is_navbar_hidden = true
		_is_navbar_visible = false
		
	elif not _is_navbar_visible and _scroll_container.scroll_vertical > 700:
		toggle_navbar_position(Vector2(0,0))
		_is_navbar_visible = true
		_is_navbar_hidden = false


func toggle_navbar_position(p_position: Vector2):
	kill_tween(_navbar_tween)
	_navbar_tween = create_tween()
	__ = _navbar_tween.tween_property(_navbar_panel, "rect_position", p_position, 0.5)
	
