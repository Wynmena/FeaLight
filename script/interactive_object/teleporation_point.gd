class_name TeleporationPoint extends InteractiveObject

@export var is_default: bool = false

@export var id: int
@export var destination_name: String
@export var des_tele_id: int #目的地的现身位置

func _ready() -> void:
	if is_default:
		$CollisionShape2D.set_deferred("disabled", true)

func _player_enter_reaction() -> void:
	if destination_name.is_empty():
		push_warning(self.name + " no destination")
		return
	Manager.GameMgr.change_map(destination_name, des_tele_id)
	
