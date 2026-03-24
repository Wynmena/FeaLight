class_name TeleporationPoint extends Node2D

@onready var interaction_component: InteractionComponent = $InteractionComponent

@export var is_default: bool = false

@export var id: int
@export var destination_name: String
@export var des_tele_id: int #目的地的现身位置

func _ready() -> void:
	if interaction_component:
		interaction_component.interact_start.connect(_on_interaction_start)
		if is_default:
			var shape = interaction_component.get_node_or_null("CollisionShape2D")
			if shape:
				shape.set_deferred("disabled", true)

func _on_interaction_start() -> void:
	if GameManager.is_develop:
		print("Interacted with teleportation point: " + self.name)
	if destination_name.is_empty():
		push_warning(self.name + " no destination")
		return
	SignalBus.request_change_map.emit(destination_name, des_tele_id)
	
