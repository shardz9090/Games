extends Control


func _on_EasyButton_pressed():
	GlobalStore.level = GlobalStore.game_level.EASY
	Transition.change_scene("res://scenes/board/main_board.tscn")


func _on_HardButton_pressed():
	GlobalStore.level = GlobalStore.game_level.HARD
	Transition.change_scene("res://scenes/board/main_board.tscn")

