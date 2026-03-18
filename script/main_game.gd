class_name MainGame extends Node2D


signal _anim_back_signal


@onready var map_root: Node2D = $MapRoot
@onready var ui_effect_layer: UIEffectLayer = $UIEffectLayer

@onready var tele_timer: Timer = $TeleTimer


@export var player: Player
@export_category("临时变量")
@export var test_map_name: String

var current_map: Map
var _can_tele: bool = true

func _ready() -> void:
	get_tree().root.ready.connect(_on_tree_ready)

func _on_tree_ready():
	tele_timer.timeout.connect(func():
		$CanvasLayer/CanTeleLabel.text = "可切换地图"
		_can_tele = true);
	Manager.GameMgr.main_game = self
	change_map_without_black_screen(test_map_name)
	

func change_map(map_name: String, tele_id: int = 0) -> void:
	if not _can_tele: return
	
	var PS: PackedScene = Manager.ResourceMgr.load_map(map_name)
	if PS == null :
		push_error("试图加载不存在的地图")
		return
		
		
	ui_effect_layer.play_black_screen(_anim_back_signal)
	#清除现有地图
	current_map = null
	player.position = Vector2(-1000, -1000)
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
	player.global_position = tele.global_position
	$CanvasLayer/Label.text = "Map : " + current_map.name
	$CanvasLayer/CanTeleLabel.text = "不可切换地图"
	_can_tele = false
	$TeleTimer.start()


func change_map_without_black_screen(map_name: String, tele_id: int = 0) -> void:
	if not _can_tele: return
	
	var PS: PackedScene = Manager.ResourceMgr.load_map(map_name)
	if PS == null :
		push_error("试图加载不存在的地图")
		return
		
	
	#清除现有地图
	current_map = null
	player.position = Vector2(-1000, -1000)
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
	
	call_deferred("_finish_map_change", tele, map_name)
	#player.global_position = tele.global_position
	#$CanvasLayer/Label.text = "Map : " + current_map.name
	#$CanvasLayer/CanTeleLabel.text = "不可切换地图"
	#_can_tele = false
	#$TeleTimer.start()
