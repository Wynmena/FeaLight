# 页面渲染管理器

extends Node


signal _anim_back_signal

var map_root: Node2D
var player: CharacterBody2D
var ui_effect_layer: UIEffectLayer
var tele_timer: Timer

var current_map: Map
var _can_tele: bool = true

var sys_menu_scene = preload("res://tscn/UI/pages/sys_menu.tscn")
var sys_menu_instance: SysMenu


func init(p_map_root: Node2D, p_player: CharacterBody2D, p_ui_effect_layer: UIEffectLayer, p_tele_timer: Timer) -> void:
	map_root = p_map_root
	player = p_player
	ui_effect_layer = p_ui_effect_layer
	tele_timer = p_tele_timer
	
	tele_timer.timeout.connect(func():_can_tele = true);


func toggle_menu() -> void:
	if sys_menu_instance == null:
		sys_menu_instance = sys_menu_scene.instantiate()
		var menu_layer: CanvasLayer = CanvasLayer.new()
		menu_layer.layer = 101 # 比黑屏动效(100)高一点，保证一定要可见不被遮挡（如果需要）
		# 或者如果想要黑屏遮住菜单，就设小一点
		
		get_tree().root.add_child(menu_layer)
		menu_layer.add_child(sys_menu_instance)
		
		sys_menu_instance.open()
	else:
		sys_menu_instance.toggle()


func change_map(map_name: String, tele_id: int = 0) -> void:
	if not _can_tele: return
	
	var PS: PackedScene = ResourceManager.load_map(map_name)
	if PS == null :
		push_error("试图加载不存在的地图")
		return
		
		
	ui_effect_layer.play_black_screen(_anim_back_signal)
	#清除现有地图
	current_map = null
	#移开玩家防止穿帮
	player.position = Vector2(-10000, -10000)
	for child in map_root.get_children():
		child.queue_free()

	#加载新地图
	var new_map = PS.instantiate()
	map_root.add_child(new_map)
	current_map = new_map
	#寻找并移动至传送点
	var tele: = current_map.get_teleporation(tele_id)
	if tele == null:
		tele = current_map.get_default_teleporation()
	
	if ui_effect_layer.is_playing("black_screen"):
		await ui_effect_layer.anim_forward_finish
	
	call_deferred("_finish_map_change", tele, map_name)


func _finish_map_change(tele, map_name: String) -> void:
	_anim_back_signal.emit()
	if tele:
		player.global_position = tele.global_position
	_can_tele = false
	if tele_timer:
		tele_timer.start()


func change_map_without_black_screen(map_name: String, tele_id: int = 0) -> void:
	# 由于不需要黑屏且不需要等待动画，直接加载
	if not _can_tele: return # 暂时保留此检查
	
	var PS: PackedScene = ResourceManager.load_map(map_name)
	if PS == null :
		push_error("试图加载不存在的地图")
		return

	#清除现有地图
	current_map = null
	player.position = Vector2(-10000, -10000)
	for child in map_root.get_children():
		child.queue_free()

	var new_map = PS.instantiate()
	map_root.add_child(new_map)
	current_map = new_map
	
	var tele: = current_map.get_teleporation(tele_id)
	if tele == null:
		tele = current_map.get_default_teleporation()
		
	if tele:
		player.global_position = tele.global_position