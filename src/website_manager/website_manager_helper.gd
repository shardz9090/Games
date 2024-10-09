class_name WebsiteHelper
extends Node


static func f_save(p_game_names, p_file_path) -> void:
	var file = File.new()
	file.open(p_file_path, File.WRITE)
	file.store_string(JSON.print(p_game_names, "\t"))
	file.close()


static func f_load(p_file_path) -> Array:
	var file = File.new()
	file.open(p_file_path, File.READ)
	var game_names = file.get_as_text()
	file.close()

	var content_json = JSON.parse(game_names)

	return content_json.result

