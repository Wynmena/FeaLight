class_name GameWorld extends Node2D


signal _anim_back_signal


@onready var map_root: Node2D = $MapRoot
# @onready var ui_effect_layer: UIEffectLayer = $UIEffectLayer

@onready var tele_timer: Timer = $TeleTimer


@export var player: Player
@export_category("临时变量")
@export var test_map_name: String

var current_map: Map
var _can_tele: bool = true


func _ready() -> void:
	# 初始化
	tele_timer.timeout.connect(func():_can_tele = true);
	
	# 初始化游戏状态
	change_map_without_black_screen(test_map_name)
	
	SignalBus.request_change_map.connect(change_map)


func change_map(map_name: String, tele_id: int = 0) -> void:
	if not _can_tele: return
	
	var PS: PackedScene = ResourceManager.load_map(map_name)
	if PS == null :
		push_error("试图加载不存在的地图")
		return
		
		
	ScreenManager.play_black_screen(_anim_back_signal)
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
	
	if ScreenManager.is_playing("black_screen"):
		await ScreenManager.anim_forward_finish
	
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
