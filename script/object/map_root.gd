class_name MapRoot extends Node2D


signal change_started
signal change_finished
signal old_map_removed
signal new_map_added

#最大缓存数
@export var max_cache_count: int = 3

var _cache_maps: Array[Map]
# ATTENTION ：current_map 不会储存在 _cache_maps 中，故实际地图数是 max_cache_count + 1
var current_map: Map

#初始化，在 GameWorld 中调用
func initlize() -> void:
	current_map = get_child(0)


# 除特殊情况， 切换地图一律使用此函数
# 特殊情况：GameWorld.first_enter_map， 直接调用此函数会出现空异常（current_map）
func safe_change_map(map_name: String) -> void:
	change_started.emit()
	var new_map: Map = get_cache_map_from_name(map_name)
	
	if new_map == null:
		var PS: PackedScene = ResourceManager.load_map(map_name)
		if PS == null or not PS.can_instantiate():
			push_error(PathUtil.map_tscn_path + map_name,".tscn is unexisted or can't instantiate.")
			return
		new_map = PS.instantiate()
		add_map(new_map)
	
	change_map(new_map)
	change_finished.emit()

func get_cache_map_from_name(map_name: String) -> Map:
	map_name = PathUtil.snake_to_pascal(map_name)
	for map: Map in _cache_maps:
		# ATTENTION : map_name 为 场景根节点 名（pascal），不是 场景资源 的文件名（snake）
		if map.map_name ==  map_name:
			return map
	return null


# 只能切换到 _cache_map 中的 Map
# 若想进入 新Map ， 请先调用 add_map()
# 请了解 Node.Remove() 与 Node.queue_free()的区别
func change_map(target_map:Map) -> void:
	if current_map == target_map and get_child_count() > 0:
		push_warning("你已在 ", target_map.map_name)
		return
	
	if not target_map in _cache_maps:
		push_error("试图加载不存在的地图")
		return
	
	if current_map == null:
		push_error("current_map is null.")
		return
	
	_cache_maps.erase(target_map)
	_cache_maps.push_back(current_map)
	current_map.on_player_exit()
	old_map_removed.emit()
	if not target_map.is_inside_tree():
		call_deferred("add_child", target_map)
	target_map.on_player_enter()
	new_map_added.emit()
	current_map = target_map


func add_map(new_map: Map) -> void:
	if new_map in _cache_maps:
		return
	# 若超出最大缓存限制，则删除第一个元素，即 最久没有使用的地图
	if len(_cache_maps) >= max_cache_count:
		_cache_maps[0].queue_free()
		_cache_maps.remove_at(0)
		#等待一帧
		await get_tree().process_frame
	_cache_maps.push_back(new_map)
