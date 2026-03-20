class_name BaseDataContainer

var datas: Array
var data_class_name: String


func _init(pascal_data_name: String) -> void:
	data_class_name = pascal_data_name
	var snake_data_name: String = PathUtil.pascal_to_snake(pascal_data_name)
	var file_path: String = PathUtil.data_class_path + snake_data_name + ".gd"
	print("File path: " + file_path)
	var script = load(file_path)
	datas = Array([], TYPE_OBJECT, "Resource", script)


#初始化数据，将 what 中的数据 转换为拥有特定类型的数据，attr_list 为所需数据的变量名
#此方法需要在子类中重写，将 Resource 类改为需要储存的数据类型
func initlize_datas(whats: Array) -> void:
	var attr_list: = get_attr_list()
	for what: Dictionary in whats:
		# instance 是即将加入datas中的元素
		var instance: Resource = Resource.new()		
		for attr_name in attr_list:
			var attr: Variant = what.get(attr_name)
			if (attr == null):
				push_warning("what without " + attr_name)
				continue
			instance.set(attr_name, attr)
		datas.append(instance)




func _get_data_from_attribute(var_name: String, what: Variant) -> Variant:
	for data in datas:
		var attr: Variant = data.get(var_name)
		if attr == null : continue
		return data
	return null


func add(new_data: Variant) -> void:
	if datas.is_typed() and datas.get_typed_class_name() == new_data.get_class():
		datas.append(new_data)
	else:
		push_warning("new_data type is not the same as the container type")


func get_attr_list() -> Array[String]:
	if not datas.is_typed():
		push_error("try get attributes from unclear class")
		return []
	var attr_list: Array[String]
	var scr: Script = datas.get_typed_script()
	for tmp in scr.get_script_property_list():
		if tmp.usage & PROPERTY_USAGE_SCRIPT_VARIABLE:
			attr_list.append(tmp.name)
	return attr_list
