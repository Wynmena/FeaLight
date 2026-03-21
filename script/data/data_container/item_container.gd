class_name ItemContainer extends BaseDataContainer

func _init() -> void:
	super._init("ItemData")


func get_item_data_from_id(id: int) -> ItemData:
	return _get_data_from_attribute("id", id)


func get_item_data_from_name(name: String) -> ItemData:
	return _get_data_from_attribute("name", name)


func initlize_datas(whats: Array) -> void:
	var attr_list: = get_attr_list()
	for what: Dictionary in whats:
		# instance 是即将加入datas中的元素
		var instance: ItemData = ItemData.new()
		for attr_name in attr_list:
			var attr: Variant = what.get(attr_name)
			if (attr == null):
				push_warning("what without " + attr_name)
				continue
			instance.set(attr_name, attr)
		datas.append(instance)
