extends Node

func _ready():
	ScreenManager.init_ui($Menu, $CurrentSceneContainer, $UIEffectLayer)


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_F):
		print("can_tele: ", TeleporationPoint.can_tele)
