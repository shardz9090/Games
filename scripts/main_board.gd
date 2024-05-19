extends Control


export(PackedScene) var card_scene


signal game_won(p_score)


const HORIZONTAL_SPACING: int = 40
const VERTICAL_SPACING: int = -85
const CARD_WIDTH_GAP: int = 64
const CARD_HEIGHT_GAP: int = 93
const CARD_INDEX_IN_DEAL_DECK: int = 15
const CARD_COLUMN_IN_SUIT: int = 10
const SCORE_FOR_CARD_TO_COLUMN: int = 5
const SCORE_FOR_SUIT_TO_COLUMN: int = -20
const SCORE_WHEN_CARD_TO_SUIT: int = 20
const DECREASE_SCORE_WHEN_COLUMN: int = 5
const DECREASE_SCORE_WHEN_REDEAL: int = 50

var move_helper = preload ("res://global/helper/move_helper.gd").new()
var undo_helper = preload ("res://global/helper/undo_helper.gd").new()
var symbols: Dictionary = GlobalStore.suit_dict
var ranks: Dictionary = GlobalStore.rank_dict

var __
var _minutes: int = 0
var _time_value: int = 0
var _card_position_tween: SceneTreeTween
var _playing_deck_tween: SceneTreeTween
var deal_deck: Array = []
var _size_of_deal_deck: int
var _deal_card_position_after_deck_pressed: Vector2 = Vector2(0, 150)
var _sending_deal_cards: Array

onready var _after_game_control: Control = $AfterGameControl
onready var _time_number_label: Label = $GameControl/VBoxContainer/StatsControl/StatsHBox/TimeVBox/TimeNumberLabel
onready var _moves_number_label: Label = $GameControl/VBoxContainer/StatsControl/StatsHBox/MovesVBox/MovesNumberLabel
onready var _score_number_label: Label = $GameControl/VBoxContainer/StatsControl/StatsHBox/ScoreVBox/ScoreNumberLabel
onready var _game_time_timer: Timer = $GameControl/VBoxContainer/StatsControl/StatsHBox/TimeVBox/GameTimeTimer
onready var _tableau_control: Control = $GameControl/VBoxContainer/TableauControl
onready var _deal_button: TextureButton = $GameControl/DealButton
onready var _window_dialog: WindowDialog = $AfterGameControl/WindowDialog
onready var _popup_timer: Timer = $GameControl/PopupTimer
onready var _win_score_label: Label = $AfterGameControl/WindowDialog/ScoreLabel
onready var _game_control: Control = $GameControl
onready var _popup_dialog: PopupDialog = $GameControl/CanvasLayer/PopupDialog


func _ready() -> void:
	_after_game_control.hide()
	_tableau_control.show()
	
	randomize()
	
	_initialize_signal_connects()
	_initialize_timer()
	_shuffle_all_cards()
	_spawn_cards_in_board()


func _initialize_signal_connects() -> void:
	__ = GlobalStore.connect("card_moved", self, "_increase_score")
	__ = connect("game_won", self, "_game_win")


func _initialize_timer() -> void:
	_game_time_timer.start()
	_time_number_label.text = "00:00"


func _shuffle_all_cards() -> void:
	var m_card_color: int
	var m_card_instance: Object

	for symbol in symbols.keys():
		for rank in ranks.keys():
			m_card_instance = card_scene.instance()
			
			if (
				symbol == GlobalStore.card_symbol.DIAMOND 
				or symbol == GlobalStore.card_symbol.HEARTS
			):
				m_card_color = GlobalStore.card_color.RED
			else:
				m_card_color = GlobalStore.card_color.BLACK
			
			
			m_card_instance.initialize(symbol, rank, m_card_color)
			
			m_card_instance.position = Vector2(0, 0)
			
			GlobalStore.all_cards.append(m_card_instance)
		
	GlobalStore.all_cards.shuffle()


func _spawn_cards_in_board() -> void:
	_spawn_cards_in_playing_columns()
	_spawn_cards_in_deal_deck()


func _spawn_cards_in_playing_columns() -> void:
	var m_index: int = 0
	var m_column_stack = []
	var m_card_stack: Array = []
	var m_column_card_instance: Object
	var m_card_original_position: Vector2
	var m_start_position: Vector2 = Vector2(150, 20)
	var m_z_index: int = 0
	var m_column_number: int = 0
	var m_is_draggable: bool
	var m_show_card_face: bool

	for i in range(GlobalStore.ROWS):
		m_column_stack = []

		
		for j in range(i):
			if (m_index < GlobalStore.playing_column_size):
				m_column_card_instance = GlobalStore.all_cards[m_index]
				
				m_card_original_position = Vector2(
					m_start_position.x + (CARD_WIDTH_GAP + HORIZONTAL_SPACING) * i,
					m_start_position.y + (CARD_HEIGHT_GAP + VERTICAL_SPACING) * j
				)
				
				m_z_index = j + 1
				m_column_number = i - 1
				m_is_draggable = false
				m_show_card_face = false
				
				m_column_card_instance.card_properties(
					m_z_index, 
					m_card_original_position, 
					m_column_number, 
					m_is_draggable, 
					m_show_card_face
				)
				
				m_column_stack.append(m_column_card_instance)
				
				GlobalStore.card_column_array[i - 1].append(m_column_card_instance)
			
			else:
				break
			
			m_index += 1
		
		m_card_stack.append(m_column_stack)
	
		if m_card_stack.size() >= GlobalStore.playing_column_size:
			break
	_show_cards_face_in_playing_column(m_card_stack)


func _show_cards_face_in_playing_column(p_card_stack: Array) -> void:
	for i in range(GlobalStore.ROWS):
		for j in range(i):
			if j == i - 1:
				p_card_stack[i][j].show_card_face(true)
				
				p_card_stack[i][j].change_draggable(true)
			
			_tableau_control.add_child(p_card_stack[i][j])
			p_card_stack[i][j]._initialize_card_position()


func _spawn_cards_in_deal_deck() -> void:
	var m_card_original_position: Vector2
	var m_show_card_face: bool
	var m_column_number: int
	var m_z_index: int
	var m_is_draggable: bool
	var m_deal_card_instance: Object
	
	for i in range(GlobalStore.playing_column_size, GlobalStore.all_cards.size()):
		m_deal_card_instance = GlobalStore.all_cards[i]
		m_card_original_position = Vector2(50, 20)
		m_show_card_face = false
		m_column_number = CARD_INDEX_IN_DEAL_DECK
		m_z_index = 1
		m_is_draggable = false
		
		m_deal_card_instance.card_properties(
			m_z_index, 
			m_card_original_position, 
			m_column_number, 
			m_is_draggable, 
			m_show_card_face
		)

		deal_deck.append(m_deal_card_instance)
		GlobalStore.deal_deck_array.append(m_deal_card_instance)
		
		_tableau_control.add_child(m_deal_card_instance)
		
	_size_of_deal_deck = deal_deck.size()


func _on_GameTimeTimer_timeout() -> void:
	var m_new_score: int
	
	_time_value += 1
	
	if _time_value < 10:
		_time_number_label.text = str(_minutes).pad_zeros(2) + " : " + str(_time_value).pad_zeros(2)
	
	elif _time_value >= 10:
		_time_number_label.text = str(_minutes).pad_zeros(2) + " : " + str(_time_value)
		
	if _time_value >= 60:
		_minutes += 1
		_time_value = 0
		_time_number_label.text = str(_minutes).pad_zeros(2) + " : " + str(_time_value)
		
	if (
		_time_value % 10 == 0 
		and GlobalStore.level == GlobalStore.game_level.HARD
	):
		m_new_score = int(_score_number_label.text) - 1
		
		if m_new_score < 0:
			m_new_score = 0
		
		_score_number_label.text = str(m_new_score)


func _on_Button_pressed() -> void:
	print(GlobalStore.deal_deck_array[1].original_position)
	if GlobalStore.playing_deal_deck.empty() and deal_deck.empty():
		return
	
	if deal_deck.empty():
		_handle_when_redeck_pressed()

	else:
		_increase_moves()
	
		if GlobalStore.level == GlobalStore.game_level.HARD:
			_handle_when_deal_pressed_for_hard_level()
				
		else:
			_handle_when_deal_pressed_for_easy_level()
			
		if not GlobalStore.playing_deal_deck.empty():
			GlobalStore.playing_deal_deck.back().change_draggable(true)
		
#		if deal_deck.size() == 0:
#			_deal_button.texture_normal = load("res://assets/images/redeck.png")


func _handle_when_redeck_pressed() -> void:
	var m_deal_card_initial_position: Vector2 = Vector2(50,20)
	move_helper.store_card_details_when_deal_deck_empty(
		GlobalStore.playing_deal_deck, 
		int(_score_number_label.text)
	)
	
	_increase_moves()
	_decrease_score(DECREASE_SCORE_WHEN_REDEAL)
	
	GlobalStore.i_in_deal = 0
	
	_size_of_deal_deck = GlobalStore.playing_deal_deck.size()
#	_deal_button.texture_normal = _deal_button.texture_disabled
	deal_deck.clear()
	deal_deck = GlobalStore.deal_deck_array.duplicate()
	
	GlobalStore.playing_deal_deck.clear()

	for deal_card in deal_deck:
		deal_card.position = m_deal_card_initial_position
		deal_card.original_position = m_deal_card_initial_position
		deal_card.change_draggable(false)
		deal_card.show_card_face(false)


func _handle_when_deal_pressed_for_hard_level() -> void:
	var m_temp_array: Array = []
	var m_temp_i: int = 0
	var m_increase_position_for_hard_level: Vector2 = Vector2(0,30)
	var m_deal_card: Object
	_kill_playing_deck_tween()
	_playing_deck_tween = create_tween().set_parallel(true)
	
	m_temp_i = GlobalStore.i_in_deal
	m_temp_array = deal_deck.duplicate(true)
	
	for _i in range(3):
		if m_temp_i < _size_of_deal_deck:
			var current_card = m_temp_array.front()
			m_temp_array.erase(current_card)
			_sending_deal_cards.insert(0, current_card)
			m_temp_i += 1
			
		else:
			continue
	
	move_helper.store_card_details_when_deal_pressed(
		_sending_deal_cards.duplicate()
	)
	_sending_deal_cards.clear()
	
	for i in range(3):
		if (GlobalStore.i_in_deal < _size_of_deal_deck):
			var m_deal_card_new_position_after_deal_deck_pressed: Vector2
			
			for card in GlobalStore.playing_deal_deck:
				card.change_draggable(false)
			
			GlobalStore.playing_deal_deck.append(deal_deck.front())
			deal_deck.erase(deal_deck.front())
			
			m_deal_card = GlobalStore.playing_deal_deck[GlobalStore.i_in_deal]
			m_deal_card.show_card_face(true)
			m_deal_card.z_index = GlobalStore.i_in_deal
			m_deal_card.original_z_index = GlobalStore.i_in_deal
			
			m_deal_card_new_position_after_deal_deck_pressed = (
				m_deal_card.original_position + _deal_card_position_after_deck_pressed 
				+ (m_increase_position_for_hard_level * i)
			)
			
			m_deal_card.original_position = m_deal_card_new_position_after_deal_deck_pressed
			
			__ = _playing_deck_tween.tween_property(GlobalStore.playing_deal_deck[GlobalStore.i_in_deal], "position", m_deal_card_new_position_after_deal_deck_pressed, 0.05)
			GlobalStore.i_in_deal += 1
			
		else:
			continue


func _handle_when_deal_pressed_for_easy_level() -> void:
	var m_deal_card_new_position_after_deal_deck_pressed: Vector2
	_sending_deal_cards.append(deal_deck.front())
	move_helper.store_card_details_when_deal_pressed(_sending_deal_cards)
	
	for card in GlobalStore.playing_deal_deck:
		card.change_draggable(false)
	
	GlobalStore.playing_deal_deck.append(deal_deck.front())
	deal_deck.erase(deal_deck.front())
	GlobalStore.playing_deal_deck[GlobalStore.i_in_deal].show_card_face(true)
	
	GlobalStore.playing_deal_deck[GlobalStore.i_in_deal].original_z_index = GlobalStore.i_in_deal
	GlobalStore.playing_deal_deck[GlobalStore.i_in_deal].z_index = GlobalStore.i_in_deal
	
	m_deal_card_new_position_after_deal_deck_pressed = GlobalStore.playing_deal_deck[GlobalStore.i_in_deal].position + _deal_card_position_after_deck_pressed
	GlobalStore.playing_deal_deck[GlobalStore.i_in_deal].original_position = m_deal_card_new_position_after_deal_deck_pressed
	
	_kill_playing_deck_tween()
	_playing_deck_tween = create_tween()
	__ = _playing_deck_tween.tween_property(GlobalStore.playing_deal_deck[GlobalStore.i_in_deal], "position", m_deal_card_new_position_after_deal_deck_pressed, 0.05)
	
	GlobalStore.i_in_deal += 1
	_sending_deal_cards.clear()


func _kill_playing_deck_tween() -> void:
	if is_instance_valid(_card_position_tween):
		_card_position_tween.stop()
		_card_position_tween.kill()

	if is_instance_valid(_playing_deck_tween):
		_playing_deck_tween.stop()
		_playing_deck_tween.kill()


func _on_SpadeSuit_body_entered(p_card_body: Object) -> void:
	var m_new_location: Vector2 = Vector2(1084,120)
	if _check_cards_moving_to_suit(p_card_body, GlobalStore.card_symbol.SPADE, GlobalStore.lowest_card_rank_spades, m_new_location, GlobalStore.spades_suit_array):
		GlobalStore.lowest_card_rank_spades += 1


func _on_ClubsSuit_body_entered(p_card_body: Object) -> void:
	var m_new_location: Vector2 = Vector2(1084, 230)
	if _check_cards_moving_to_suit(p_card_body, GlobalStore.card_symbol.CLUBS, GlobalStore.lowest_card_rank_clubs, m_new_location, GlobalStore.clubs_suit_array):
		GlobalStore.lowest_card_rank_clubs += 1


func _on_HeartsSuit_body_entered(p_card_body: Object) -> void:
	var m_new_location: Vector2 = Vector2(1084,340)
	if _check_cards_moving_to_suit(p_card_body, GlobalStore.card_symbol.HEARTS, GlobalStore.lowest_card_rank_hearts, m_new_location, GlobalStore.hearts_suit_array):
		GlobalStore.lowest_card_rank_hearts += 1


func _on_DiamondsSuit_body_entered(p_card_body: Object) -> void:
	var m_new_location: Vector2 = Vector2(1084,10)
	if _check_cards_moving_to_suit(p_card_body, GlobalStore.card_symbol.DIAMOND, GlobalStore.lowest_card_rank_diamonds, m_new_location, GlobalStore.diamonds_suit_array):
		GlobalStore.lowest_card_rank_diamonds += 1


func _check_cards_moving_to_suit(p_card_body: Object, p_card_symbol: int, p_lowest_card_rank: int, p_new_location: Vector2, p_suit_array: Array) -> bool:
	if p_card_body.card_symbol == p_card_symbol and p_card_body.self_column_number != 10 and not p_card_body._is_card_migrated_successfully:
		if p_card_body.card_rank == p_lowest_card_rank and GlobalStore.face_up_overlapping_bodies.empty():
			var _last_face_down_card_of_column: Object = null

			_last_face_down_card_of_column = GlobalStore.face_down_card
			
			move_helper.store_card_details_when_moved_to_suit(p_card_body, _last_face_down_card_of_column)
			
			p_card_body.original_position = p_new_location
			p_card_body.z_index = p_lowest_card_rank
			p_card_body.original_z_index = p_lowest_card_rank
			
			p_lowest_card_rank += 1
			_on_cards_moving_to_suit(p_card_body, p_suit_array, p_new_location)
			GlobalStore.take_mouse_in = true
			p_card_body.is_mouse_in = false
			return true
		return false
	return false


func _on_cards_moving_to_suit(p_card_body, p_suit_name, p_original_positon) -> void:
	var m_temp_column_number = p_card_body.self_column_number
	if p_card_body.self_column_number <= GlobalStore.COLUMNS:
		p_suit_name.append(p_card_body)
		GlobalStore.card_column_array[p_card_body.self_column_number].erase(p_card_body)
		GlobalStore.emit_signal("card_migrated", p_card_body, p_card_body.self_column_number)

		CardHelper.reset_disabled_cards()
		
	else:
		GlobalStore.i_in_deal -= 1

		GlobalStore.playing_deal_deck.erase(p_card_body)
		p_suit_name.append(p_card_body)
		GlobalStore.deal_deck_array.erase(p_card_body)

		if not GlobalStore.playing_deal_deck.empty():
			GlobalStore.playing_deal_deck.back().change_draggable(true)
	
	for card in p_suit_name:
		if card == p_suit_name.back():
			card.change_draggable(true)

		else:
			card.change_draggable(false)

	p_card_body.self_column_number = CARD_COLUMN_IN_SUIT
	GlobalStore.suit_card_array.append(p_card_body)
	p_card_body.z_index = p_card_body.card_rank
	
	p_card_body.is_dragging = false
	
	p_card_body._kill_card_move_tween()
	p_card_body._card_move_tween = create_tween()
	__ = p_card_body._card_move_tween.tween_property(p_card_body, "position", p_original_positon, 0.2).set_ease(Tween.EASE_OUT)
	
	GlobalStore.emit_signal("card_moved", m_temp_column_number, CARD_COLUMN_IN_SUIT)
	
	count_suit_card()
	CardHelper._reset_all_cards_mouse_in()


func _increase_score(p_last_column: int, p_new_column: int) -> void:
	if (
		p_last_column <= GlobalStore.COLUMNS and p_new_column <= GlobalStore.COLUMNS
		) or (
			p_last_column == GlobalStore.DEAL_COLUMN and p_new_column <= GlobalStore.COLUMNS
		):
		_score_number_label.text = str(int(_score_number_label.text) + SCORE_FOR_CARD_TO_COLUMN)

	elif (
		p_last_column == GlobalStore.DEAL_COLUMN and p_new_column == GlobalStore.SUIT_COLUMN
		) or (
			p_last_column <= GlobalStore.COLUMNS and p_new_column == GlobalStore.SUIT_COLUMN
		):
		_score_number_label.text = str(int(_score_number_label.text) + SCORE_WHEN_CARD_TO_SUIT)

	elif p_last_column == GlobalStore.SUIT_COLUMN and p_new_column <= GlobalStore.COLUMNS:
		_score_number_label.text = str(int(_score_number_label.text) + SCORE_FOR_SUIT_TO_COLUMN)
		
	_increase_moves()


func _increase_moves() -> void:
	_moves_number_label.text = str(int(_moves_number_label.text) + 1)


func _decrease_score(p_decrement: int) -> void:
	_score_number_label.text = str(int(_score_number_label.text) - p_decrement)
		
	if int(_score_number_label.text) < 0:
		_score_number_label.text = str(0)


func _on_NewGameTextureButton_pressed() -> void:
	_clear_all()
	__ = get_tree().reload_current_scene()


func _clear_all() -> void:
	__ = get_tree().call_group("cards", "queue_free")
	
	CardHelper.clear_all_globals()


func _check_if_king_is_in_empty(p_card_body: Object):
	if p_card_body.is_card_face_up and p_card_body.is_dragging and p_card_body.self_column_number <= 7:
		if p_card_body.card_rank == GlobalStore.card_no_face_rank.KING:
			if GlobalStore.card_column_array[p_card_body.self_column_number].front() == p_card_body:
				return true
			return false
		return false


func _on_column1_body_entered(p_card_body: Object) -> void:
	if _check_if_king_is_in_empty(p_card_body):
		return
	_on_card_moved_to_empty_column(0, p_card_body, Vector2(254, 20))


func _on_column2_body_entered(p_card_body: Object) -> void:
	if _check_if_king_is_in_empty(p_card_body):
		return
	_on_card_moved_to_empty_column(1, p_card_body, Vector2(358, 20))


func _on_column3_body_entered(p_card_body: Object) -> void:
	if _check_if_king_is_in_empty(p_card_body):
		return
	_on_card_moved_to_empty_column(2, p_card_body, Vector2(462, 20))


func _on_column4_body_entered(p_card_body: Object) -> void:
	if _check_if_king_is_in_empty(p_card_body):
		return
	_on_card_moved_to_empty_column(3, p_card_body, Vector2(566, 20))


func _on_column5_body_entered(p_card_body: Object) -> void:
	if _check_if_king_is_in_empty(p_card_body):
		return
	_on_card_moved_to_empty_column(4, p_card_body, Vector2(670, 20))


func _on_column6_body_entered(p_card_body: Object) -> void:
	if _check_if_king_is_in_empty(p_card_body):
		return
	_on_card_moved_to_empty_column(5, p_card_body, Vector2(774, 20))


func _on_column7_body_entered(p_card_body: Object) -> void:
	if _check_if_king_is_in_empty(p_card_body):
		return
	_on_card_moved_to_empty_column(6, p_card_body, Vector2(878, 20))


func _on_card_moved_to_empty_column(p_column_number: int, p_card_body: Object, p_new_position: Vector2) -> void:
	if GlobalStore.card_column_array[p_column_number].size() == 0:
		if p_card_body.is_card_face_up and p_card_body.is_dragging:
			if p_card_body.card_rank == GlobalStore.card_no_face_rank.KING:
				p_card_body.is_mouse_in = false
				p_card_body.is_taking_input = false
				move_helper.store_card_previous_state_for_king_to_empty_area(p_card_body, p_column_number, GlobalStore.face_up_overlapping_bodies)
				
				p_card_body.original_position = p_new_position
				_move_cards_to_new_position(p_card_body, p_new_position, p_column_number)


func _move_cards_to_new_position(p_card_body: Object, p_original_positon: Vector2, p_new_column: int) -> void:
	_increase_moves()
	GlobalStore.take_mouse_in = true
	if p_card_body.self_column_number <= GlobalStore.COLUMNS:
		if not GlobalStore.card_column_array[p_card_body.self_column_number].front() == p_card_body:
			_increase_score(p_card_body.self_column_number, p_new_column)
	
	p_card_body.z_index = 1
	p_card_body.original_z_index = 1
	p_card_body.is_dragging = false
	p_card_body.card_return()
	
	CardHelper.change_card_current_details(p_card_body, p_new_column, p_original_positon)


func _on_UndoButton_pressed() -> void:
	if GlobalStore.latest_move.size() == 0:
		_popup_dialog.popup()
		_popup_timer.start()
	
	else:
		_moves_number_label.text = str(int(_moves_number_label.text) - 1)
		
		match GlobalStore.latest_move.back().front()["action"]:
			GlobalStore.card_last_move.DEAL_DECK_TO_PLAYING_DEAL_DECK:
				_handle_undo_when_last_was_deal_pressed()
			
			GlobalStore.card_last_move.PLAYING_DEAL_DECK_TO_COLUMN:
				_decrease_score(DECREASE_SCORE_WHEN_COLUMN)
				_handle_undo_when_last_was_playing_deal_deck_to_column()
			
			GlobalStore.card_last_move.COLUMN_TO_COLUMN:
				_decrease_score(DECREASE_SCORE_WHEN_COLUMN)
				_handle_undo_when_last_was_column_to_column()
			
			GlobalStore.card_last_move.SUIT_TO_COLUMN:
				_increase_score(GlobalStore.COLUMNS, GlobalStore.SUIT_COLUMN)
				_handle_undo_when_last_was_suit_to_column()
			
			GlobalStore.card_last_move.COLUMN_TO_SUIT:
				_decrease_score(DECREASE_SCORE_WHEN_COLUMN)
				_handle_undo_when_last_was_to_suit()
				
			GlobalStore.card_last_move.EMPTY_DEAL_DECK:
				_handle_undo_when_last_was_empty_deck()


func _handle_undo_when_last_was_empty_deck() -> void:
	var m_last_move_arr: Array = GlobalStore.latest_move.back()

	_deal_button.texture_normal = load("res://assets/images/redeck.png")
	_score_number_label.text = str(m_last_move_arr.front()["last_score"])
	_kill_playing_deck_tween()
	_card_position_tween = create_tween().set_parallel(true)
	
	for card_dicts in m_last_move_arr:
		var m_card = card_dicts["card"]
		deal_deck.erase(m_card)
		
		m_card.original_position = card_dicts["card_position"]
		m_card.show_card_face(card_dicts["card_face"])
		m_card.change_draggable(card_dicts["card_is_draggable"])
		m_card.original_z_index = card_dicts["card_z_index"]
		m_card.z_index = card_dicts["card_z_index"]
		m_card.self_column_number = card_dicts["card_self_column_number"]
		
		__ = _card_position_tween.tween_property(m_card, "position", m_card.original_position, 0.05)
		GlobalStore.playing_deal_deck.append(m_card)
	GlobalStore.i_in_deal = GlobalStore.playing_deal_deck.size()
	GlobalStore.latest_move.pop_back()


func _handle_undo_when_last_was_to_suit() -> void:
	var m_last_move_dict: Dictionary = GlobalStore.latest_move.back().front()

	var m_card = m_last_move_dict["card"]
	GlobalStore.suit_card_array.erase(m_card)

	m_card.show_card_face(m_last_move_dict["card_face"])
	m_card.original_position = m_last_move_dict["card_position"]
	m_card.original_z_index = m_last_move_dict["card_z_index"]
	m_card.z_index = m_last_move_dict["card_z_index"]
	m_card.self_column_number = m_last_move_dict["card_self_column_number"]

	if m_card.self_column_number <= GlobalStore.COLUMNS:
		GlobalStore.card_column_array[m_card.self_column_number].append(m_card)
	else:
		GlobalStore.deal_deck_array.append(m_card)
		GlobalStore.playing_deal_deck.append(m_card)

		for card in GlobalStore.playing_deal_deck:
			if not card == GlobalStore.playing_deal_deck.back():
				card.change_draggable(false)
			else:
				card.change_draggable(true)
		GlobalStore.i_in_deal += 1
	
	if m_last_move_dict["last_face_down_card"]:
		m_last_move_dict["last_face_down_card"].change_draggable(false)
		m_last_move_dict["last_face_down_card"].show_card_face(false)
	
	CardHelper.remove_card_from_suit(m_card)

	_move_back_undoed_card(m_card, m_card.original_position)

	GlobalStore.latest_move.pop_back()


func _handle_undo_when_last_was_suit_to_column() -> void:
	var m_last_move_dict: Dictionary = GlobalStore.latest_move.back().front()
	var m_card = m_last_move_dict["card"]

	GlobalStore.card_column_array[m_card.self_column_number].erase(m_card)
	
	m_card.show_card_face(m_last_move_dict["card_face"])
	m_card.original_position = m_last_move_dict["card_position"]
	m_card.original_z_index = m_last_move_dict["card_z_index"]
	m_card.z_index = m_last_move_dict["card_z_index"]
	m_card.self_column_number = m_last_move_dict["card_self_column_number"]

	CardHelper._append_card_in_suit(m_card)

	_move_back_undoed_card(m_card, m_card.original_position)

	GlobalStore.latest_move.pop_back()


func _handle_undo_when_last_was_column_to_column() -> void:
	var m_last_move_arr: Array = GlobalStore.latest_move.back()
	
	_kill_playing_deck_tween()
	_card_position_tween = create_tween().set_parallel(true)
	
	for dicts in m_last_move_arr:
		var m_card = dicts["card"]
		
		GlobalStore.card_column_array[m_card.self_column_number].erase(m_card)
		
		m_card.show_card_face(dicts["card_face"])
		m_card.original_position = dicts["card_position"]
		m_card.original_z_index = dicts["card_z_index"]
		m_card.z_index = dicts["card_z_index"]
		m_card.self_column_number = dicts["card_self_column_number"]
		
		if dicts["last_face_down_card"]:
			dicts["last_face_down_card"].change_draggable(false)
			dicts["last_face_down_card"].show_card_face(false)
		
		GlobalStore.card_column_array[m_card.self_column_number].push_back(m_card)
		__ = _card_position_tween.tween_property(m_card, "position", m_card.original_position, 0.1)
	
	GlobalStore.latest_move.pop_back()


func _move_back_undoed_card(p_undo_card: Object, p_previous_position: Vector2) -> void:
	_kill_playing_deck_tween()
	_card_position_tween = create_tween()
	__ = _card_position_tween.tween_property(p_undo_card, "position", p_previous_position, 0.1)


func _handle_undo_when_last_was_playing_deal_deck_to_column() -> void:
	var m_last_move_dict: Dictionary = GlobalStore.latest_move.back().front()
	var m_card = m_last_move_dict["card"]
	
	GlobalStore.card_column_array[m_card.self_column_number].erase(m_card)
	
	m_card.show_card_face(m_last_move_dict["card_face"])
	m_card.original_position = m_last_move_dict["card_position"]
	m_card.original_z_index = m_last_move_dict["card_z_index"]
	m_card.z_index = m_last_move_dict["card_z_index"]
	m_card.self_column_number = m_last_move_dict["card_self_column_number"]
	
	GlobalStore.i_in_deal += 1
	
	GlobalStore.playing_deal_deck.push_back(m_card)
	GlobalStore.latest_move.pop_back()
	
	for card in GlobalStore.playing_deal_deck:
		card.change_draggable(false)
	
	m_card.change_draggable(m_last_move_dict["card_is_draggable"])
	
	_move_back_undoed_card(m_card, m_card.original_position)


func _handle_undo_when_last_was_deal_pressed() -> void:
	var m_last_move_arr: Array = GlobalStore.latest_move.back()
	_kill_playing_deck_tween()
	_card_position_tween = create_tween().set_parallel(true)

	for card_dicts in m_last_move_arr:
		var m_card = card_dicts["card"]

		m_card.original_position = card_dicts["card_position"]
		m_card.change_draggable(card_dicts["card_is_draggable"])
		m_card.original_z_index = card_dicts["card_z_index"]
		m_card.z_index = card_dicts["card_z_index"]

		__ = _card_position_tween.tween_property(m_card, "position", m_card.original_position, 0.1)
		m_card.show_card_face(card_dicts["card_face"])

		GlobalStore.playing_deal_deck.erase(m_card)
		deal_deck.push_front(m_card)

		GlobalStore.i_in_deal -= 1

	if not GlobalStore.playing_deal_deck.empty():
		GlobalStore.playing_deal_deck.back().change_draggable(true)
	GlobalStore.latest_move.pop_back()


func _on_PopupTimer_timeout() -> void:
	_popup_dialog.hide()


func count_suit_card() -> void:
	if GlobalStore.suit_card_array.size() == 52:
		emit_signal("game_won", int(_score_number_label.text))


func _game_win(p_score: int) -> void:
	_game_control.hide()
	_win_score_label.text = str(p_score)
	_window_dialog.popup()


func _on_CancelButton_pressed() -> void:
	get_tree().quit()


func _on_EasyButton_pressed() -> void:
	GlobalStore.level = GlobalStore.game_level.EASY
	_clear_all()
	_window_dialog.hide()
	__ = get_tree().reload_current_scene()


func _on_HardButton_pressed() -> void:
	GlobalStore.level = GlobalStore.game_level.HARD
	_clear_all()
	_window_dialog.hide()
	__ = get_tree().reload_current_scene()


func _on_HomeButton_pressed() -> void:
	_clear_all()
	Transition.change_scene("res://scenes/ui/mainmenu.tscn")
