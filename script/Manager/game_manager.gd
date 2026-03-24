# 状态管理器

extends Node

signal load_completed

# 开发模式开关
var is_develop: bool = true

var game_data = preload("res://script/data/game_data.gd").new()


func _ready() -> void:
	pass


func _on_load_requested(slot_path: String) -> void:
	if is_develop:
		print("Load requested: ", slot_path)
	var loaded_data = GameData.load_from_json(slot_path)
	if loaded_data:
		game_data = loaded_data
		SignalBus.load_game_completed.emit()
	
