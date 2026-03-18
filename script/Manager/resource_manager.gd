class_name ResourceManager extends Node


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
	
