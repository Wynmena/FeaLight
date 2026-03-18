class_name InteractiveObject extends Area2D

func _init() -> void:
	self.area_entered.connect(_on_area_entered)
	self.area_exited.connect(_on_area_exited)

func _player_enter_reaction() -> void:
	pass


func _player_exited_reaction() -> void:
	pass


func _is_player(body: Node2D) -> bool:
	if body.is_in_group("Player") or body.owner.is_in_group("Player"):
		return true
	return false


func _on_area_entered(node: Node2D) -> void:
	if _is_player(node):
		_player_enter_reaction()


func _on_area_exited(node: Node2D) -> void:
	if _is_player(node):
		_player_exited_reaction()
