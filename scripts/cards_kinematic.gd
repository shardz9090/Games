extends KinematicBody2D


const STACK_CARD_GAPS: Vector2 = Vector2(0,30)
const GAPS_WHEN_OVERLAPPING: Vector2 = Vector2(0, 20)

var move_helper = preload ("res://global/helper/move_helper.gd").new()
var card_symbol: int
var card_rank: int
var card_color: int
var is_card_face_up: bool

var is_draggable: bool
var is_dragging: bool
var is_taking_input: bool
var is_mouse_in: bool

var original_position: Vector2
var original_z_index: int

var self_column_number: int

var __
var _card_move_tween: SceneTreeTween
var _is_card_migrated_successfully: bool
var current_body: Object
var _direction: Vector2
var _dragging_distance: float
var _increment_of_positions: Vector2

onready var _card_front_texture_rect: TextureRect = $FrontControl/TextureRect


func _ready() -> void:
	original_z_index = self.z_index
	_initialize_card_position()
	_card_front_texture_rect.texture = load(CardHelper.path_of_card_image(card_rank, card_symbol))
	
	__ = GlobalStore.connect("card_migrated", self, "on_card_migrated")


func _initialize_card_position() -> void:
	_kill_card_move_tween()
	_card_move_tween = create_tween()
	__ = _card_move_tween.tween_property(self, "position", original_position, 1).set_ease(Tween.EASE_OUT)



func _input(p_event) -> void:
#	if p_event is InputEventMouseButton and is_draggable:
#		_for_mouse_clicked(p_event)
#
#	elif p_event is InputEventMouseMotion:
#		_handle_for_dragging_mouse()

	if p_event is InputEventScreenDrag and is_draggable and p_event.index == 0:
		if is_mouse_in:
			if not self in GlobalStore.touched_cards:
				GlobalStore.touched_cards.append(self)
				
				if self_column_number <= GlobalStore.COLUMNS:
					CardHelper.drag_valid_overlapping_cards(self)
				
				z_index += 100
				is_dragging = true
				is_taking_input = true
				
				GlobalStore.take_mouse_in = false
			
			_handle_drag_for_Android(p_event)


func initialize(p_symbol: int, p_rank: int, p_color: int) -> void:
	card_symbol = p_symbol
	card_rank = p_rank
	card_color = p_color


func card_properties(p_z_index, p_card_original_position, p_column_number, p_is_draggable, p_show_card_face) -> void:
	z_index = p_z_index
	original_position = p_card_original_position
	self_column_number = p_column_number
	is_draggable = p_is_draggable
	is_card_face_up = p_show_card_face

	


func _on_KinematicBody2D_input_event(_viewport, p_event, _shape_idx) -> void:
	if p_event is InputEventScreenTouch and is_draggable and p_event.index == 0:
		if p_event.is_pressed():
			if GlobalStore.take_mouse_in:
				GlobalStore.touched_cards.clear()
				
				if self_column_number <= GlobalStore.COLUMNS:
					for card in GlobalStore.card_column_array[self_column_number]:
						if card.original_z_index < self.original_z_index:
							is_mouse_in = false
							card.card_return()
					
				is_mouse_in = true
			
		elif not p_event.is_pressed():
			self.is_mouse_in = false
			GlobalStore.touched_cards.clear()
			GlobalStore.take_mouse_in = true
			_handle_when_mouse_click_finished()


func _handle_drag_for_Android(p_event: Object) -> void:
	if is_draggable:
		position += p_event.relative
		
		if not GlobalStore.face_up_overlapping_bodies.empty():
			_increment_of_positions = GAPS_WHEN_OVERLAPPING
			
			for card in GlobalStore.face_up_overlapping_bodies:
				card.position = position + _increment_of_positions
				_increment_of_positions += GAPS_WHEN_OVERLAPPING


func _for_mouse_clicked(p_event: Object) -> void:
	if is_mouse_in:
		if p_event.is_pressed():
			is_dragging = true
			is_taking_input = true
			z_index += 100
			
			start_dragging()
			
		elif not p_event.is_pressed():
			_handle_when_mouse_click_finished()


func _handle_for_dragging_mouse() -> void:
	var _new_position: Vector2
	
	if is_dragging and is_mouse_in and is_taking_input:
		_new_position = get_viewport().get_mouse_position() - _dragging_distance * _direction
		position = _new_position
		
		if not GlobalStore.face_up_overlapping_bodies.empty():
			_increment_of_positions = GAPS_WHEN_OVERLAPPING
			
			for card in GlobalStore.face_up_overlapping_bodies:
				card.position = position + _increment_of_positions
				_increment_of_positions += GAPS_WHEN_OVERLAPPING


func _handle_when_mouse_click_finished() -> void:
	var m_is_card_in_suit_deck: int
	
	is_dragging = false
	
	if current_body != null:
		
		_is_card_migrated_successfully = true
	
		m_is_card_in_suit_deck = GlobalStore.suit_card_array.find(self)
		
		if m_is_card_in_suit_deck >= 0:
			_handle_move_when_card_in_suit_deck()
		
		else:
			_handle_move_when_card_not_in_suit_deck()
		
	if is_taking_input:
		stop_dragging()
		is_taking_input = false
		
	if _is_card_migrated_successfully:
		_is_card_migrated_successfully = false
	
	current_body = null


func _handle_move_when_card_not_in_suit_deck() -> void:
	var m_temp_card_column_number: int
	
	m_temp_card_column_number = self_column_number
	
	if self_column_number <= GlobalStore.COLUMNS:
		move_helper.store_card_details_when_moved_from_column_to_column(self, GlobalStore.face_up_overlapping_bodies, GlobalStore.face_down_card)
		
		CardHelper.migrate_card_from_column_to_column(self, current_body)
		
		GlobalStore.emit_signal("card_migrated", self, m_temp_card_column_number)
		
	elif self in GlobalStore.playing_deal_deck:
		move_helper.store_card_details_when_moved_from_playing_deck_to_column(self)
		CardHelper.remove_card_from_playing_deal_deck(self, current_body)
		
	GlobalStore.emit_signal("card_moved", self_column_number, current_body.self_column_number)
	self_column_number = current_body.self_column_number
	
	z_index = current_body.z_index + 1
	original_z_index = z_index
	original_position = current_body.position + STACK_CARD_GAPS
	
	_kill_card_move_tween()
	_card_move_tween = create_tween().set_parallel(true)
	__ = _card_move_tween.tween_property(self, "position", original_position, 0.2).set_ease(Tween.EASE_OUT)
	
	set_position_for_overlapping_bodies()


func _handle_move_when_card_in_suit_deck() -> void:
	var m_suit_index: int = 0
	
	move_helper.store_card_details_when_moved_from_suit_to_column(self)
	
	original_position = current_body.position + STACK_CARD_GAPS
	
	CardHelper.remove_card_from_suit(self)

	GlobalStore.card_column_array[current_body.self_column_number].append(self)
	GlobalStore.suit_card_array.erase(self)

	GlobalStore.emit_signal("card_moved", self_column_number, current_body.self_column_number)
	
	self_column_number = current_body.self_column_number
	original_z_index = current_body.original_z_index + 1
	z_index = original_z_index


func on_card_migrated(p_card: Object, p_column_number: int) -> void:
	if p_card == self:
		return
	
	if p_column_number != self_column_number:
		return
	
	if GlobalStore.card_column_array[self_column_number].size() > 0 and GlobalStore.card_column_array[self_column_number].back() == self:
		show_card_face(true)
		self.change_draggable(true)


func change_draggable(p_is_draggable: bool) -> void:
	is_draggable = p_is_draggable


func start_dragging() -> void:
	_dragging_distance = position.distance_to(get_viewport().get_mouse_position())
	_direction = (get_viewport().get_mouse_position() - position).normalized()
	
	if self_column_number <= GlobalStore.COLUMNS:
		CardHelper.drag_valid_overlapping_cards(self)


func stop_dragging() -> void:
	z_index = original_z_index
	GlobalStore.take_mouse_in = true
	
	if self_column_number <= GlobalStore.COLUMNS:
		CardHelper.reset_disabled_cards()
		
	GlobalStore.disabled_cards.clear()
	
	if position != original_position:
		card_return()
	
	if not _is_card_migrated_successfully and not GlobalStore.face_up_overlapping_bodies.empty():
		for card in GlobalStore.face_up_overlapping_bodies:
			card.card_return()
			card.is_dragging = false
			
		GlobalStore.face_up_overlapping_bodies.clear()


func set_position_for_overlapping_bodies() -> void:
	var m_increase_position_for_overlapping_bodies: Vector2 = STACK_CARD_GAPS
	var m_increase_z_index_for_overlapping_bodies: int = 1

	for card in GlobalStore.face_up_overlapping_bodies:
		card.is_dragging = false
		card.original_position = (self.original_position + m_increase_position_for_overlapping_bodies)
		card.original_z_index = self.z_index + m_increase_z_index_for_overlapping_bodies

		card.card_return()

		m_increase_position_for_overlapping_bodies += STACK_CARD_GAPS
		m_increase_z_index_for_overlapping_bodies += 1
	GlobalStore.face_up_overlapping_bodies.clear()


func show_card_face(p_is_face_up: bool) -> void:
	if not p_is_face_up:
		$FrontControl/TextureRect.hide()
		$BackControl/TextureRect.show()
		
	else:
		$FrontControl/TextureRect.show()
		$BackControl/TextureRect.hide()
	
	is_card_face_up = p_is_face_up


func _kill_card_move_tween() -> void:
	if is_instance_valid(_card_move_tween):
		_card_move_tween.stop()
		_card_move_tween.kill()


func card_return() -> void:
	_kill_card_move_tween()
	_card_move_tween = create_tween().set_parallel(true)
	__ = _card_move_tween.tween_property(self, "position", original_position, 0.2).set_ease(Tween.EASE_OUT)
	__ = _card_move_tween.tween_property(self, "z_index", original_z_index, 0.01)


func _on_Area2D_body_entered(p_body: Object) -> void:
	if p_body.is_card_face_up and is_dragging:
		if p_body.card_rank == self.card_rank + 1 and p_body.card_color != self.card_color:
			if p_body.self_column_number != self.self_column_number:
				if not p_body in GlobalStore.suit_card_array and not p_body in GlobalStore.playing_deal_deck:
					if (GlobalStore.card_column_array[p_body.self_column_number].back() == p_body):
						_is_card_migrated_successfully = true
						current_body = p_body
