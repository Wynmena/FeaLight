class_name MainGame extends Node2D


signal _anim_back_signal


@onready var map_root: Node2D = $MapRoot
@onready var ui_effect_layer: UIEffectLayer = $UIEffectLayer

@onready var tele_timer: Timer = $TeleTimer


@export var player: Player
@export_category("临时变量")
@export var test_map_name: String


func _ready() -> void:
	# 初始化场景管理器
	SceneManager.init(map_root, player, ui_effect_layer, tele_timer)
	
	# 等待树准备就绪
	get_tree().root.ready.connect(_on_tree_ready)


func _on_tree_ready():
	# 初始化游戏状态
	SceneManager.change_map_without_black_screen(test_map_name)

	GameManager.init_game()
