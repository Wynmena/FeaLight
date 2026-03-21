class_name Item extends RefCounted


var _data: ItemData


var name: String:
	get:
		return _data.name
var description: String:
	get:
		return _data.desc
var id: int:
	get:
		return _data.id
var icon_path: String:
	get:
		return _data.icon


func _init(data: ItemData) -> void:
	_data = data
