extends Control

signal request_start_game

func _on_start_button_pressed() -> void:
	request_start_game.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
