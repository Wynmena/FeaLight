extends Node

var ResourceMgr: ResourceManager = \
	preload("res://script/Manager/resource_manager.gd").new():
	set(value):
		pass
var GameMgr: GameManager = \
	preload("res://script/Manager/game_manager.gd").new():
	set(value):
		pass
var DataMgr: DataManager = \
	preload("res://script/Manager/data_manager.gd").new():
	set(value):
		pass
var BugMgr: BugManager = \
	preload("res://script/Manager/bug_manager.gd").new():
	set(value):
		pass

func _ready() -> void:
	add_child(ResourceMgr)
	add_child(GameMgr)
	add_child(DataMgr)
	add_child(BugMgr)
