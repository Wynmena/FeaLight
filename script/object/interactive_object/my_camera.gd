@tool
extends Camera2D

@export var target: Node2D


func _physics_process(delta: float) -> void:
	if not target == null:
		self.position = target.position
