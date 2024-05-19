extends Control


export(PackedScene) var button_scene
export(PackedScene) var placeholder_scene


var _grid_row_and_column_size: int = 10
var _starting_number_of_buttons: int
var _buttons_grid_space: Array
var _random_position: Vector2
var _x_position: float
var _y_position: float
var _sequence: Array
var minimum_distance: int = 100
var _clicked_buttons: Array = []
var _progress_tween: SceneTreeTween
var _is_hard: bool
var _is_medium: bool
var _is_easy: bool
var _times_correct: int = 0
var sequence_helper = load("res://sequence.gd").new()

onready var _score: Label = $MarginContainer/VBoxContainer/score_and_progress/score
onready var _spawn_area: Panel = $MarginContainer/VBoxContainer/spawn_area
onready var _grid_container: GridContainer = $MarginContainer/VBoxContainer/spawn_area/GridContainer
onready var _hud: Control = $HUD
onready var _timer: Timer = $Timer
onready var _progress_bar: ProgressBar = $MarginContainer/VBoxContainer/score_and_progress/ProgressBar
onready var _game_over_sound: AudioStreamPlayer = $GameOverSound
onready var _score_and_progress_node: Control = $MarginContainer/VBoxContainer/score_and_progress


func _ready() -> void:
	_score_and_progress_node.show()
	_hud.hide()
	
	if Global.level == "easy":
		_is_easy = true
		_progress_bar.hide()
		_starting_number_of_buttons = 2
	elif Global.level == "medium":
		_is_medium = true
		_starting_number_of_buttons = 3
		_timer.start()
		_progress_bar.hide()
	else:
		_is_hard = true
		_timer.start()
		_starting_number_of_buttons = 4
	
	Sequence.length_of_sequence = _starting_number_of_buttons
	Sequence.make_sequence()
	
	_spawn_buttons()
	_update_score()
	
	if _is_hard or _is_medium:
		_disable_all_buttons()
		_timer.start()


func _spawn_placeholder() -> void:
	var m_max_placeholders: int = 10 - Sequence.length_of_sequence
	var m_number_of_placeholder: int = m_max_placeholders - int(rand_range(0,5))
	
	if m_number_of_placeholder <= 0:
		return
	
	while(m_number_of_placeholder>0):
		var _button_instance = placeholder_scene.instance()
		_grid_container.add_child(_button_instance)
		m_number_of_placeholder -=1


func _update_score() -> void:
	_score.text = str(Sequence.length_of_sequence)


func _level_up() -> void:
	_times_correct += 1
	_kill_progress_tween()
	
	_clicked_buttons = []
	
	for child in _grid_container.get_children():
		_grid_container.remove_child(child)
		child.queue_free()

	Sequence.length_of_sequence += 1
	Sequence.make_sequence()
	_update_score()
	_spawn_buttons()
	
	if _is_hard or _is_medium:
		_disable_all_buttons()
		_timer.start()


func _disable_all_buttons() -> void:
	for child in _grid_container.get_children():
		child.set_button_disabled(true)


func _enable_all_buttons() -> void:
	for child in _grid_container.get_children():
		child.set_button_disabled(false)


func game_over() -> void:
	var m_score = _times_correct
	
	if Global.level == "easy":
		m_score *= 1
	elif Global.level == "medium":
		m_score *= 2
	else:
		m_score *= 3
	
	_kill_progress_tween()
	
	save(m_score)
	
	if Global.is_sound_on:
		_game_over_sound.play()
	
	_hud.score = int(m_score)
	_spawn_area.hide()
	
	Sequence.length_of_sequence = _starting_number_of_buttons
	Sequence.make_sequence()
	
	_score_and_progress_node.hide()
	_hud.show()


func save(p_content) -> void:
	if p_content > Global.high_score:
		var file = File.new()
		file.open("res://save_game.dat", File.WRITE)
		file.store_string(str(p_content))
		file.close()


func _spawn_buttons() -> void:
	var _button_instances = []
	_spawn_placeholder()
	
	for i in range(1, Sequence.length_of_sequence + 1):
		var _button_instance = button_scene.instance()
		_button_instance.connect("key_pressed", self, "_on_button_key_pressed")
		_button_instance._text_to_display = str(i)
		_button_instance.button_number = i
		_button_instances.append(_button_instance)
	
	_button_instances.shuffle()
	
	for button_instance in _button_instances:
		_grid_container.add_child(button_instance)
		_spawn_placeholder()


func _on_back_button_pressed() -> void:
	if Global.is_sfx_on:
		SfxSound.play()
	
	Transition.change_scene("res://Home.tscn")


func _on_button_key_pressed(p_key: int) -> void:
	if _is_hard:
		_start_progress()
	
	_clicked_buttons.append(str(p_key))

	for child in _grid_container.get_children():
		var _button_number_str = str(child.button_number)
		
		if !(_button_number_str in _clicked_buttons):
			child.is_flipped = true

	if p_key == Sequence.sequence.pop_front():
		if Sequence.sequence.size()==0:
			_level_up()
	else:
		_kill_progress_tween()
		game_over()


func _on_Timer_timeout() -> void:
	_enable_all_buttons()
	_flip_all_buttons()
	
	if _is_hard:
		_kill_progress_tween()
		_start_progress()


func _flip_all_buttons() -> void:
	for child in _grid_container.get_children():
		if not child.is_flipped:
			child.is_flipped = true


func _start_progress() -> void:
	_progress_bar.value = 0
	
	_kill_progress_tween()
	
	_progress_tween = create_tween()
	var __ = _progress_tween.tween_property(_progress_bar, "value", 100, 1)


func _on_ProgressBar_value_changed(p_value) -> void:
	if p_value >=100:
		_kill_progress_tween()
		game_over()


func _kill_progress_tween() -> void:
	if is_instance_valid(_progress_tween):
		_progress_tween.stop()
		_progress_tween.kill()
