class_name GameManager extends Node

var main_game: MainGame

func change_map(map_name: String, tele_id: int = 0) -> void:
	if main_game == null:
		main_game = get_tree().root.find_child("MainGame")
		print(main_game)
	main_game.change_map(map_name, tele_id)
	
