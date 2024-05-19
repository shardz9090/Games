class_name MoveHelper

extends Reference


static func store_card_previous_state_for_king_to_empty_area(p_card, p_new_column, p_overlapping_cards):
	if p_card.self_column_number <= 7:
		store_card_details_when_moved_from_column_to_column(p_card, p_overlapping_cards, GlobalStore.face_down_card)
	elif p_card in GlobalStore.suit_card_array:
		store_card_details_when_moved_from_suit_to_column(p_card)
	elif p_card.self_column_number == 15:
		store_card_details_when_moved_from_playing_deck_to_column(p_card)


static func _append_each_move(p_card, p_new_column):
	var _each_card_move: Dictionary = {
			"action": GlobalStore.card_last_move.KING_TO_EMPTY_AREA,
			"card": p_card,
			"card_position": p_card.original_position,
			"card_z_index": p_card.original_z_index,
			"self_column_number": p_card.self_column_number,
			"card_face": p_card.is_card_face_up,
			"new_column_number": p_new_column
		}
	
	GlobalStore.moved_card_details.append(_each_card_move)


static func store_card_details_when_deal_pressed(p_card):
	var _card_details: Dictionary = {}
	for cards in p_card:
		_card_details = {
			"action": GlobalStore.card_last_move.DEAL_DECK_TO_PLAYING_DEAL_DECK,
			"card": cards,
			"card_rank": cards.card_rank,
			"card_position": cards.original_position,
			"card_z_index": cards.original_z_index,
			"card_face": cards.is_card_face_up,
			"card_is_draggable": cards.is_draggable,
			}
		GlobalStore.moved_card_details.append(_card_details)

	GlobalStore.latest_move.append(GlobalStore.moved_card_details.duplicate(true))
	GlobalStore.moved_card_details.clear()


static func store_card_details_when_moved_from_column_to_column(p_card, p_overlapping_bodies, p_face_down_card):
	var _card_details: Dictionary = {}
	_card_details = {
		"action": GlobalStore.card_last_move.COLUMN_TO_COLUMN,
		"card": p_card,
		"card_rank": p_card.card_rank,
		"card_position": p_card.original_position,
		"card_z_index": p_card.original_z_index,
		"card_face": p_card.is_card_face_up,
		"card_is_draggable": p_card.is_draggable,
		"card_self_column_number": p_card.self_column_number,
		"last_face_down_card": p_face_down_card,
		}

	GlobalStore.moved_card_details.push_back(_card_details)

	if not p_overlapping_bodies.empty():
		for bodies in p_overlapping_bodies:
			_card_details = {
				"action": GlobalStore.card_last_move.COLUMN_TO_COLUMN,
				"card": bodies,
				"card_rank": bodies.card_rank,
				"card_position": bodies.original_position,
				"card_z_index": bodies.original_z_index,
				"card_face": bodies.is_card_face_up,
				"card_is_draggable": bodies.is_draggable,
				"card_self_column_number": bodies.self_column_number,
				"last_face_down_card": p_face_down_card,
				}

			GlobalStore.moved_card_details.push_back(_card_details)
	
	GlobalStore.latest_move.push_back(GlobalStore.moved_card_details.duplicate(true))

	GlobalStore.moved_card_details.clear()
	GlobalStore.face_down_card = null


static func store_card_details_when_moved_to_suit(p_card, p_face_down_card):
	var _card_details: Dictionary = {}
	_card_details = {
		"action": GlobalStore.card_last_move.COLUMN_TO_SUIT,
		"card": p_card,
		"card_rank": p_card.card_rank,
		"card_position": p_card.original_position,
		"card_z_index": p_card.original_z_index,
		"card_face": p_card.is_card_face_up,
		"card_is_draggable": p_card.is_draggable,
		"card_self_column_number": p_card.self_column_number,
		"last_face_down_card": p_face_down_card,
		}
	
	GlobalStore.moved_card_details.append(_card_details)

	GlobalStore.latest_move.append(GlobalStore.moved_card_details.duplicate(true))

	GlobalStore.moved_card_details.clear()
	GlobalStore.face_down_card = null


static func store_card_details_when_moved_from_suit_to_column(p_card):
	var _card_details: Dictionary = {}
	_card_details = {
		"action": GlobalStore.card_last_move.SUIT_TO_COLUMN,
		"card": p_card,
		"card_rank": p_card.card_rank,
		"card_position": p_card.original_position,
		"card_z_index": p_card.original_z_index,
		"card_face": p_card.is_card_face_up,
		"card_is_draggable": p_card.is_draggable,
		"card_self_column_number": p_card.self_column_number
		}
	
	GlobalStore.moved_card_details.push_back(_card_details)

	GlobalStore.latest_move.push_back(GlobalStore.moved_card_details.duplicate(true))

	GlobalStore.moved_card_details.clear()


static func store_card_details_when_moved_from_playing_deck_to_column(p_card: Object):
	var _card_details: Dictionary = {}
	_card_details = {
		"action": GlobalStore.card_last_move.PLAYING_DEAL_DECK_TO_COLUMN,
		"card": p_card,
		"card_rank": p_card.card_rank,
		"card_position": p_card.original_position,
		"card_z_index": p_card.original_z_index,
		"card_face": p_card.is_card_face_up,
		"card_is_draggable": p_card.is_draggable,
		"card_self_column_number": p_card.self_column_number
		}
	
	GlobalStore.moved_card_details.push_back(_card_details)

	GlobalStore.latest_move.push_back(GlobalStore.moved_card_details.duplicate(true))

	GlobalStore.moved_card_details.clear()


static func store_card_details_when_deal_deck_empty(p_cards: Array, p_score: int):
	for cards in p_cards:
		var _card_details: Dictionary = {
			"action": GlobalStore.card_last_move.EMPTY_DEAL_DECK,
			"card": cards,
			"card_rank": cards.card_rank,
			"card_position": cards.original_position,
			"card_z_index": cards.original_z_index,
			"card_face": cards.is_card_face_up,
			"card_is_draggable": cards.is_draggable,
			"card_self_column_number": cards.self_column_number,
			"last_score": p_score,
		}
		GlobalStore.moved_card_details.append(_card_details)
	GlobalStore.latest_move.append(GlobalStore.moved_card_details.duplicate(true))
	GlobalStore.moved_card_details.clear()
