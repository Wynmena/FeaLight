class_name InteractionComponent extends Area2D

signal interact_start # area_entered
signal interact_end # area_exited

@export var target_group: String = "Player"

func _init() -> void:
	self.area_entered.connect(_on_area_entered)
	self.area_exited.connect(_on_area_exited)

func _is_target(node: Node2D) -> bool:
	if node.is_in_group(target_group) or (node.owner and node.owner.is_in_group(target_group)):
		return true
	return false

func _on_area_entered(node: Node2D) -> void:
	if _is_target(node):
		interact_start.emit()

func _on_area_exited(node: Node2D) -> void:
	if _is_target(node):
		interact_end.emit()


func close_collision() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)


func open_collision() -> void:
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	
