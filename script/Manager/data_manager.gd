class_name DataManager extends Node


var item: ItemContainer

func _init() -> void:
	item = ItemContainer.new()
	item.initlize_datas(_load_json("items"))
	print(item.get_item_from_id(1).name)

func _load_json(json_name: String) -> Array:
	var json_path: String = PathUtil.json_data_path + json_name + ".json"

	var file: FileAccess = FileAccess.open(json_path, FileAccess.READ)
	var json_string: String = file.get_as_text()
	
	var json: JSON = JSON.new()
	var parse_error = json.parse(json_string)
	
	if parse_error != OK:
		push_error("JSON解析错误: ", json.get_error_message(), " 在第 ", json.get_error_line(), " 行")
		return []
	else:
		return json.data
			
