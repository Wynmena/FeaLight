class_name TeleporationPoint extends BaseInteractiveObject

@onready var interaction_component: InteractionComponent = $InteractionComponent

@export var is_default: bool = false

@export var id: int
@export var destination_name: String
@export var des_tele_id: int #目的地的现身位置

# 从 传送点A 前往 传送点B 时，B时也会调用 _on_interaction_start，然后陷入死循环
# can_tele 可以避免陷入死循环
static var can_tele: bool = true
static var last_tele_point: TeleporationPoint
func _ready() -> void:
	if interaction_component:
		interaction_component.interact_start.connect(_on_interaction_start)
		interaction_component.interact_end.connect(_on_interaction_end)
		if is_default:
			var shape = interaction_component.get_node_or_null("CollisionShape2D")
			if shape:
				shape.set_deferred("disabled", true)

func _on_interaction_start() -> void:
	if can_tele == false:
		return
	if GameManager.is_develop:
		print("Interacted with teleportation point: " + self.name)
	if destination_name.is_empty():
		push_warning(self.name + " no destination")
		return
	last_tele_point = self
	can_tele = false
	SignalBus.request_change_map.emit(destination_name, des_tele_id)


func _on_interaction_end() -> void:
	if can_tele == false and last_tele_point != self:
		can_tele = true
