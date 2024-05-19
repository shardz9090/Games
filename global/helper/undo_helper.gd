class_name UndoHelper


extends Reference


# var _last_move_arr: Array
# var _last_move_dict: Dictionary
# var __
# var _card_position_tween: SceneTreeTween


# func _kill_playing_deck_tween() -> void:
# 	if is_instance_valid(_card_position_tween):
# 		_card_position_tween.stop()
# 		_card_position_tween.kill()


# func _handle_undo_when_last_was_deal_pressed(p_deal_deck: Array) -> Array:
# 	_last_move_arr = GlobalStore.latest_move.back()
# 	_kill_playing_deck_tween()
# 	_card_position_tween = create_tween().set_parallel(true)

# 	for card_dicts in _last_move_arr:
# 		var m_card = card_dicts["card"]

# 		m_card.original_position = card_dicts["card_position"]
# 		m_card.show_card_face(card_dicts["card_face"])
# 		m_card.change_draggable(card_dicts["card_is_draggable"])
# 		m_card.original_z_index = card_dicts["card_z_index"]
# 		m_card.z_index = card_dicts["card_z_index"]
		
# 		__ = _card_position_tween.tween_property(m_card, "position", m_card.original_position, 0.1)

# 		GlobalStore.playing_deal_deck.erase(m_card)
# 		p_deal_deck.push_front(m_card)
	
# 		GlobalStore.i_in_deal -= 1
		
# 	if not GlobalStore.playing_deal_deck.empty():
# 		GlobalStore.playing_deal_deck.back().change_draggable(true)
	
# 	GlobalStore.latest_move.pop_back()
# 	print(p_deal_deck.size())

# 	return p_deal_deck
