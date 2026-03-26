class_name Player extends CharacterBody2D


@export var speed: float = 300
var is_operable: bool = true 

func _physics_process(delta: float) -> void:
	#不可操作状态下直接 return
	if not is_operable: return
	
	var dir: Vector2 = \
	Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	if dir.length() > 0.1:
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
