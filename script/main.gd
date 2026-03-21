extends Node


var current_scene = null

func _ready():
	_init_global_ui()
	# 游戏启动，先加载主菜单
	load_scene("res://tscn/UI/pages/main_menu.tscn")


func _init_global_ui() -> void:
	# 创建全局菜单层（CanvasLayer）
	var menu_layer = CanvasLayer.new()
	menu_layer.layer = 101 # 确保高于 UI 特效层
	menu_layer.name = "GlobalMenuLayer"
	add_child(menu_layer)
	
	# 注册给 ScreenManager
	ScreenManager.set_global_menu_layer(menu_layer)


func load_scene(path: String) -> void:
	# 1. 移除当前场景（如果有）
	if current_scene:
		current_scene.queue_free()
	
	# 2. 实例化新场景
	var new_scene_res = load(path)
	current_scene = new_scene_res.instantiate()
	
	# 3. 添加到树中
	$CurrentSceneContainer.add_child(current_scene)
	
	# 4. 连接信号
	_connect_signals(current_scene)


func _connect_signals(scene: Node) -> void:
	# 如果是主菜单，连接它的开始信号
	if scene.has_signal("request_start_game"):
		if not scene.request_start_game.is_connected(_on_start_game):
			scene.request_start_game.connect(_on_start_game)


func _on_start_game() -> void:
	# 收到开始游戏请求，加载游戏世界
	load_scene("res://tscn/game_world.tscn")
