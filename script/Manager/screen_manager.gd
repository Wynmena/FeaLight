# 页面渲染管理器

extends Node

# 预加载的场景
var sys_menu_scene = preload("res://tscn/sys_menu.tscn")
var main_menu_scene = preload("res://tscn/main_menu.tscn")
var game_world_scene = preload("res://tscn/game_world.tscn")


var sys_menu_instance: SysMenu
var main_menu_instance: Control
var game_world_instance: GameWorld

var global_menu_layer: CanvasLayer
var cur_container_node: Node
var ui_effect_layer: UIEffectLayer

signal anim_forward_finish

func _ready() -> void:
	SignalBus.load_game_completed.connect(_on_start_game)


func init_ui(sys_menu_node: Node, current_container: Node, effect_layer_node: UIEffectLayer = null) -> void:
	# 初始化，仅在程序启动时调用

	# 设置全局菜单层引用，供后续使用
	global_menu_layer = sys_menu_node
	cur_container_node = current_container
	ui_effect_layer = effect_layer_node

	if ui_effect_layer:
		ui_effect_layer.anim_forward_finish.connect(func(): anim_forward_finish.emit())
	
	# 实例化并挂载主菜单
	if main_menu_scene:
		main_menu_instance = main_menu_scene.instantiate()
		global_menu_layer.add_child(main_menu_instance)


func play_black_screen(back_signal: Signal) -> void:
	if ui_effect_layer:
		ui_effect_layer.play_black_screen(back_signal)


func is_playing(anim_name: String) -> bool:
	if ui_effect_layer:
		return ui_effect_layer.is_playing(anim_name)
	return false


func _on_start_game() -> void:
	if GameManager.is_develop:
		print("Starting game, loading world scene...")
	if game_world_scene:
		game_world_instance = game_world_scene.instantiate()
		cur_container_node.add_child(game_world_instance)
	
	if main_menu_instance:
		main_menu_instance.queue_free()
		main_menu_instance = null

	if sys_menu_instance:
		if sys_menu_instance.visible:
			sys_menu_instance.close()
		sys_menu_instance.queue_free()

	if sys_menu_scene:
		sys_menu_instance = sys_menu_scene.instantiate()
		global_menu_layer.add_child(sys_menu_instance)


func _on_load_game() -> void:
	if main_menu_instance:
		main_menu_instance.queue_free()
		main_menu_instance = null

	if sys_menu_scene:
		sys_menu_instance = sys_menu_scene.instantiate()
		global_menu_layer.add_child(sys_menu_instance)
		sys_menu_instance.open()
		sys_menu_instance.switch_to_tab("Saves")

func toggle_menu() -> void:
	if global_menu_layer == null:
		push_error("Global Menu Layer not set!")
		return

	if sys_menu_instance == null:
		sys_menu_instance = sys_menu_scene.instantiate()
		global_menu_layer.add_child(sys_menu_instance)
		sys_menu_instance.open()
	else:
		sys_menu_instance.toggle()
