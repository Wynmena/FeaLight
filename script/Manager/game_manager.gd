# 状态管理器

extends Node

# 开发模式开关
var is_develop: bool = true

var bug_manager = preload("res://script/Manager/bug_manager.gd").new()


func _ready() -> void:
	add_child(bug_manager)


func init_game() -> void:
	bug_manager.add_item_from_id(1, 1)
	bug_manager.add_item_from_id(2, 1)
	bug_manager.add_item_from_id(3, 1)
	
