class_name CardHelper

extends Reference


static func path_of_card_image(p_rank: int, p_symbol: int) -> String:
	var m_card_rank = GlobalStore.rank_dict[p_rank]
	var m_card_symbol = GlobalStore.suit_dict[p_symbol]
	var img_path = "res://assets/images/cards/{rank}_of_{symbol}.png".format(
		{"rank": m_card_rank, "symbol": m_card_symbol}
		)
	
	return img_path


static func clear_all_globals() -> void:
	GlobalStore.suit_card_array.clear()
	GlobalStore.latest_move.clear()
	GlobalStore.i_in_deal = 0
	GlobalStore.lowest_card_rank_clubs = 1
	GlobalStore.lowest_card_rank_diamonds = 1
	GlobalStore.lowest_card_rank_hearts = 1
	GlobalStore.lowest_card_rank_spades = 1
	GlobalStore.playing_deal_deck.clear()
	GlobalStore.face_up_overlapping_bodies.clear()
	GlobalStore.clubs_suit_array.clear()
	GlobalStore.hearts_suit_array.clear()
	GlobalStore.diamonds_suit_array.clear()
	GlobalStore.spades_suit_array.clear()
	GlobalStore.deal_deck_array.clear()
	GlobalStore.moved_card_details.clear()
	GlobalStore.touched_cards.clear()
	GlobalStore.take_mouse_in = true
	GlobalStore.all_cards.clear()
	
	for i in range(GlobalStore.COLUMNS):
		GlobalStore.card_column_array[i].clear()


static func drag_valid_overlapping_cards(p_self: Object) -> void:
	var m_last_face_down_card: Array = []
	GlobalStore.face_up_overlapping_bodies.clear()
	for card in GlobalStore.card_column_array[p_self.self_column_number]:
		if not card.is_card_face_up:
			m_last_face_down_card.append(card)
		
		if (
			card.is_card_face_up 
			and card != p_self 
			and card.card_rank < p_self.card_rank
		):
			
			GlobalStore.face_up_overlapping_bodies.append(card)
		
		elif card.card_rank > p_self.card_rank and card.is_card_face_up:
			card.is_dragging = false
			card.change_draggable(false)
			card.z_index = card.original_z_index
			
			GlobalStore.disabled_cards.append(card)
		
	if not GlobalStore.face_up_overlapping_bodies.empty():
		_drag_face_up_cards_below(p_self)
	
	if not m_last_face_down_card.empty():
		GlobalStore.face_down_card = m_last_face_down_card.back()


static func _drag_face_up_cards_below(p_self) -> void:
	for card in GlobalStore.face_up_overlapping_bodies:
		if card == p_self:
			continue
		card.z_index += 100
		card.is_dragging = true


static func changes_to_current_suit(p_suit_array: Array, p_self: Object):
	var m_suit_index: int = 0
	m_suit_index = p_suit_array.find(p_self)
	p_suit_array.erase(p_self)
	
	if m_suit_index > 0:
		p_suit_array.back().change_draggable(true)


static func remove_card_from_suit(p_self: Object):
	match p_self.card_symbol:
		GlobalStore.card_symbol.DIAMOND:
			changes_to_current_suit(GlobalStore.diamonds_suit_array, p_self)
			GlobalStore.lowest_card_rank_diamonds -= 1
			
		GlobalStore.card_symbol.CLUBS:
			changes_to_current_suit(GlobalStore.clubs_suit_array, p_self)
			GlobalStore.lowest_card_rank_clubs -= 1
			
		GlobalStore.card_symbol.HEARTS:
			changes_to_current_suit(GlobalStore.hearts_suit_array, p_self)
			GlobalStore.lowest_card_rank_hearts -= 1
			
		GlobalStore.card_symbol.SPADE:
			changes_to_current_suit(GlobalStore.spades_suit_array, p_self)
			GlobalStore.lowest_card_rank_spades -= 1
			
		_:
			pass


static func remove_card_from_playing_deal_deck(p_self, p_current_body):
	GlobalStore.i_in_deal -= 1
	GlobalStore.card_column_array[p_current_body.self_column_number].append(p_self)
	GlobalStore.playing_deal_deck.erase(p_self)
	GlobalStore.deal_deck_array.erase(p_self)
	
	if not GlobalStore.playing_deal_deck.empty():
		GlobalStore.playing_deal_deck.back().change_draggable(true)


static func migrate_card_from_column_to_column(p_self, p_current_body):
	GlobalStore.card_column_array[p_current_body.self_column_number].append(p_self)
		
	for card in GlobalStore.face_up_overlapping_bodies:
		GlobalStore.card_column_array[p_current_body.self_column_number].append(card)
		GlobalStore.card_column_array[p_self.self_column_number].erase(card)
		card.self_column_number = p_current_body.self_column_number
	
	GlobalStore.card_column_array[p_self.self_column_number].erase(p_self)


static func change_card_current_details(
	p_card_body: Object, 
	p_new_column: int, 
	p_original_positon: Vector2
) -> void:
	
	if p_card_body in GlobalStore.playing_deal_deck:
		GlobalStore.i_in_deal -= 1
		GlobalStore.card_column_array[p_new_column].append(p_card_body)
		GlobalStore.deal_deck_array.erase(p_card_body)
		GlobalStore.playing_deal_deck.erase(p_card_body)
		
		if not GlobalStore.playing_deal_deck.empty():
			GlobalStore.playing_deal_deck.back().change_draggable(true)
		
	elif p_card_body in GlobalStore.suit_card_array:
		GlobalStore.card_column_array[p_new_column].append(p_card_body)
		GlobalStore.suit_card_array.erase(p_card_body)
		
		match p_card_body.card_symbol:
			GlobalStore.card_symbol.CLUBS:
				remove_king_from_suit(GlobalStore.clubs_suit_array, p_card_body)
				GlobalStore.lowest_card_rank_clubs -= 1
		
			GlobalStore.card_symbol.DIAMOND:
				remove_king_from_suit(GlobalStore.diamonds_suit_array, p_card_body)
				GlobalStore.lowest_card_rank_diamonds -= 1
		
			GlobalStore.card_symbol.HEARTS:
				remove_king_from_suit(GlobalStore.hearts_suit_array, p_card_body)
				GlobalStore.lowest_card_rank_hearts -= 1
		
			GlobalStore.card_symbol.SPADE:
				remove_king_from_suit(GlobalStore.spades_suit_array, p_card_body)
				GlobalStore.lowest_card_rank_spades -= 1
	
	else:
		var _increase_overlapping_position = Vector2(0,30)
		
		GlobalStore.card_column_array[p_new_column].append(p_card_body)
		GlobalStore.card_column_array[p_card_body.self_column_number].erase(p_card_body)
		
		for card in GlobalStore.face_up_overlapping_bodies:
			GlobalStore.card_column_array[p_new_column].append(card)
			GlobalStore.card_column_array[p_card_body.self_column_number].erase(card)
			
			card.self_column_number = p_new_column
			card.is_dragging = false
			card.original_position = p_original_positon + _increase_overlapping_position
			card.card_return()
			_increase_overlapping_position += Vector2(0,30)
		
		GlobalStore.emit_signal("card_migrated", p_card_body, p_card_body.self_column_number)
		
	p_card_body.self_column_number = p_new_column
	
	_reset_all_cards_mouse_in()


static func remove_king_from_suit(p_suit_array: Array, p_card_body: Object) -> void:
	p_suit_array.erase(p_card_body)


static func _reset_all_cards_mouse_in():
	for card in GlobalStore.all_cards:
		card.is_mouse_in = false


static func _append_card_in_suit(p_card: Object) -> void:
	match p_card.card_symbol:
		GlobalStore.card_symbol.HEARTS:
			GlobalStore.hearts_suit_array.append(p_card)
			GlobalStore.lowest_card_rank_hearts = p_card.card_rank + 1

		GlobalStore.card_symbol.DIAMOND:
			GlobalStore.diamonds_suit_array.append(p_card)
			GlobalStore.lowest_card_rank_diamonds = p_card.card_rank + 1

		GlobalStore.card_symbol.CLUBS:
			GlobalStore.clubs_suit_array.append(p_card)
			GlobalStore.lowest_card_rank_clubs = p_card.card_rank + 1

		GlobalStore.card_symbol.SPADE:
			GlobalStore.spades_suit_array.append(p_card)
			GlobalStore.lowest_card_rank_spades = p_card.card_rank + 1

		_:
			pass


static func reset_disabled_cards() -> void:
	for card in GlobalStore.disabled_cards:
		card.change_draggable(true)
		card.z_index = card.original_z_index
		card.is_mouse_in = false
