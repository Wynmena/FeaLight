extends Control

signal request_start_game
signal request_load_game


func _ready() -> void:
	self.request_start_game.connect(ScreenManager._on_start_game)
	self.request_load_game.connect(ScreenManager._on_load_game)

func _on_start_button_pressed() -> void:
	request_start_game.emit()

func _on_load_button_pressed() -> void:
	request_load_game.emit()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
