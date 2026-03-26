class_name Map extends Node2D

#目前地图没有 ID， 暂时用根节点名字区分
var map_name: String:
	get:
		return self.name

@onready var inter_objs_root: Node2D = $InteractiveObjects
@onready var tmap_layer: TileMapLayer = $TileMapLayer


func on_player_enter() -> void:
	if inter_objs_root == null: inter_objs_root = $InteractiveObjects
	if tmap_layer == null: tmap_layer = $TileMapLayer
	
	#开启 地图中 所有 BaseInteractiveObject 的 interaction_component
	for root in inter_objs_root.get_children():
		for obj: BaseInteractiveObject in root.get_children():
			obj.open_all_interaction_component()
	
	#开启 tilemaplayer 的 碰撞检测
	tmap_layer.collision_enabled = true
	
	self.show()


func on_player_exit() -> void:
	if inter_objs_root == null: inter_objs_root = $InteractiveObjects
	if tmap_layer == null: tmap_layer = $TileMapLayer
	
	for root in inter_objs_root.get_children():
		for obj: BaseInteractiveObject in root.get_children():
			obj.close_all_interaction_component()
	
	tmap_layer.collision_enabled = false
	
	self.hide()


func get_all_teleporations():
	return $InteractiveObjects/Teleporations.get_children()


func get_teleporation(id: int) -> TeleporationPoint:
	for tele: TeleporationPoint in get_all_teleporations():
		if tele.id == id and not tele.is_default:
			return tele
	return null


func get_default_teleporation() -> TeleporationPoint:
	for tele: TeleporationPoint in get_all_teleporations():
		if tele.is_default:
			return tele
	return null
