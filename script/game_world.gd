class_name GameWorld extends Node2D


@onready var map_root: MapRoot = $MapRoot


@export var player: Player
@export_category("临时变量")
@export var test_map_name: String


func _ready() -> void:
	# 初始化游戏状态
	first_enter_map(test_map_name)
	
	SignalBus.request_change_map.connect(change_map)


func change_map(map_name: String, tele_id: int = 0) -> void:
	# 转场时玩家不可移动
	player.is_operable = false
	
	ScreenManager.play_ui_efct_anim(UIEffectLayer.AnimType.BLACK_SCREEN)
	await SignalBus.ui_eff_anim_finished
	
	
	map_root.safe_change_map(map_name)
	
	#寻找并移动至传送点
	var tele: = map_root.current_map.get_teleporation(tele_id)
	if tele == null:
		tele = map_root.current_map.get_default_teleporation()
	
			
	if tele:
		player.global_position = tele.global_position
	
	ScreenManager.play_ui_efct_anim_backwards(UIEffectLayer.AnimType.BLACK_SCREEN)
	await SignalBus.ui_eff_anim_finished
	
	player.is_operable = true


func first_enter_map(map_name: String, tele_id: int = 0) -> void:	
	map_root.change_started.emit()
	var PS: PackedScene = ResourceManager.load_map(map_name)
	if PS == null or not PS.can_instantiate():
		push_error(PathUtil.map_tscn_path + map_name,".tscn is unexited or can't instantiate.")
		return
	var new_map: Map = PS.instantiate()
	map_root.current_map = new_map # ATTENTION : 无此行会有空异常
	
	map_root.add_map(new_map)
	map_root.change_map(new_map)
	map_root.change_finished.emit()
	
	#寻找并移动至传送点
	var tele: = map_root.current_map.get_teleporation(tele_id)
	if tele == null:
		tele = map_root.current_map.get_default_teleporation()
		
	if tele:
		player.global_position = tele.global_position
