class_name BugManager extends Node


var _items: Dictionary[Item, int]


func get_all_item() -> Array[Item]:
	return _items.keys()


func get_all_item_and_count() -> Dictionary[Item, int]:
	return _items


func try_get_item_from_id(id: int, ins_item: Item) -> bool:
	for item in _items.keys():
		if item.id == id:
			ins_item = item
			return true
	ins_item = null
	return false


func try_get_item_from_name(name: String, ins_item: Item) -> bool:
	for item in _items.keys():
		if item.name == name:
			ins_item = item
			return true
	ins_item = null
	return false


func add_item_from_id(id: int, count: int) -> void:
	var item: Item = null
	if try_get_item_from_id(id, item):
		_items[item] += count
	else:
		var data: ItemData = Manager.DataMgr.item.get_item_data_from_id(id)
		if data == null:
			push_error("try add unexited item_data")
			return
		item = Item.new(data)
		_items.set(item, count)


func add_item_from_name(name: String, count: int) -> void:
	var item: Item = null
	if try_get_item_from_name(name, item):
		_items[item] += count
	else:
		var data: ItemData = Manager.DataMgr.item.get_item_data_from_name(name)
		if data == null:
			push_error("try add unexited item_data")
			return
		item = Item.new(data)
		_items.set(item, count)


func try_cost_item_from_id(id: int, count: int) -> bool:
	var item: Item = null
	if try_get_item_from_id(id, item) or _items[item] < count:
		return false
	_items[item] -= count
	return false


func try_cost_item_from_name(name: String, count: int) -> bool:
	var item: Item = null
	if try_get_item_from_name(name, item) or _items[item] < count:
		return false
	_items[item] -= count
	return false
	
