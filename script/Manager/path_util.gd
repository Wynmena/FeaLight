extends Node


const map_tscn_path: String = "res://tscn/map/"

#原始数据文件夹
const json_data_path: String = "res://art/data/"
# 存放data类脚本的文件夹
const data_class_path: String = "res://script/data/"


static func pascal_to_snake(pascal_string: String) -> String:
	var snake_string = ""
	var previous_char_is_lowercase = false
	
	for i in range(pascal_string.length()):
		var current_char = pascal_string[i]
		
		# 检查当前字符是否为大写字母
		if current_char >= 'A' and current_char <= 'Z':
			# 如果前一个字符是小写字母或数字，且这不是第一个字符，则添加下划线
			if i > 0 and previous_char_is_lowercase:
				snake_string += "_"
			# 将大写字母转为小写后追加
			snake_string += current_char.to_lower()
			previous_char_is_lowercase = false
		else:
			# 非大写字母（小写字母、数字等）直接追加
			snake_string += current_char
			previous_char_is_lowercase = (current_char >= 'a' and current_char <= 'z')
	
	return snake_string
