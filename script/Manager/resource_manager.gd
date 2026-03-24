# 资源加载器

extends Node

var item_data: Dictionary = {}

func _ready() -> void:
	_load_item_data()

func _load_item_data() -> void:
	var file_path = "res://art/data/items.json"
	if not FileAccess.file_exists(file_path):
		printerr("Item data file not found: " + file_path)
		return
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	
	if error == OK:
		var data = json.data
		if data is Array:
			for item in data:
				if item.has("id"):
					item_data[int(item["id"])] = item
	else:
		printerr("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())

func load_map(file_name: String) -> PackedScene:
	return _load_resource(PathUtil.map_tscn_path, file_name, ".tscn")


func _load_resource(file_path: String, file_name: String, suffix: String = "") -> Resource:
	var all_path: = file_path.path_join(file_name)
	if not suffix.is_empty():
		all_path += suffix
	
	var res = null
	if ResourceLoader.exists(all_path):
		res = ResourceLoader.load(all_path)
	return res
	
