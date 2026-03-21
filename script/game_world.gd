class_name GameWorld extends Node2D


signal _anim_back_signal


@onready var map_root: Node2D = $MapRoot
@onready var ui_effect_layer: UIEffectLayer = $UIEffectLayer

@onready var tele_timer: Timer = $TeleTimer


@export var player: Player
@export_category("临时变量")
@export var test_map_name: String


func _ready() -> void:
	# 初始化场景管理器
	ScreenManager.init(map_root, player, ui_effect_layer, tele_timer)
	
	# 初始化游戏状态
	ScreenManager.change_map_without_black_screen(test_map_name)

	GameManager.init_game()
