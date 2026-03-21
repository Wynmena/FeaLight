class_name SysMenu extends Control

@onready var content_container: Control = $HBoxContainer/ContentContainer
@onready var content_label: Label = $HBoxContainer/ContentContainer/ContentLabel

# 预加载各个页面的场景
const OVERVIEW_PAGE_SCENE = preload("res://tscn/UI/pages/overview_page.tscn")
const INVENTORY_PAGE_SCENE = preload("res://tscn/UI/pages/inventory_page.tscn")
const SAVES_PAGE_SCENE = preload("res://tscn/UI/pages/saves_page.tscn")
const SETTINGS_PAGE_SCENE = preload("res://tscn/UI/pages/system_page.tscn")

var current_page: Node = null
var current_tab_name: String = ""

func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS # Ensure loop continues when game paused if we pause game
	
	# Connect buttons
	$HBoxContainer/TabContainer/OverViewTab.pressed.connect(func(): 
		#print("Overview Clicked")
		_on_tab_selected("Overview"))
	$HBoxContainer/TabContainer/InventoryTab.pressed.connect(func(): 
		#print("Inventory Clicked")
		_on_tab_selected("Inventory"))
	$HBoxContainer/TabContainer/SavesTab.pressed.connect(func(): 
		#print("Saves Clicked")
		_on_tab_selected("Saves"))
	$HBoxContainer/TabContainer/SettingTab.pressed.connect(func(): 
		#print("Settings Clicked")
		_on_tab_selected("Settings"))
	
	# Default selection
	_apply_theme()
	_on_tab_selected("Overview")

func _unhandled_input(event: InputEvent) -> void:
	if visible and event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			close()
			get_viewport().set_input_as_handled()

func _apply_theme() -> void:
	# 背景色
	if has_node("ColorRect"):
		$ColorRect.color = GameTheme.COLOR_BACKGROUND
		
	# 按钮样式
	_update_tab_styles()
		
	# 内容面板背景
	var content_panel = $HBoxContainer/ContentContainer
	if content_panel:
		var style = GameTheme.get_style_box_flat(GameTheme.COLOR_PANEL_BG, 10)
		content_panel.add_theme_stylebox_override("panel", style)

func _update_tab_styles() -> void:
	var tabs = {
		"Overview": $HBoxContainer/TabContainer/OverViewTab,
		"Inventory": $HBoxContainer/TabContainer/InventoryTab,
		"Saves": $HBoxContainer/TabContainer/SavesTab,
		"Settings": $HBoxContainer/TabContainer/SettingTab
	}
	
	for t_name in tabs:
		var btn = tabs[t_name]
		if not btn: continue
		
		# 首先应用基础样式
		GameTheme.apply_button_theme(btn)
		
		# 如果是当前选中的 Tab，覆盖其 normal 样式为选中色
		if t_name == current_tab_name:
			var selected_style = GameTheme.get_style_box_flat(GameTheme.BTN_COLOR_SELECTED)
			btn.add_theme_stylebox_override("normal", selected_style)
			# 让 hover 状态也保持选中感，或者稍微亮一点
			btn.add_theme_stylebox_override("hover", selected_style)

func open() -> void:
	#print("SysMenu Opened")
	show()
	get_tree().paused = true # Optional: pause game

func close() -> void:
	#print("SysMenu Closed")
	hide()
	get_tree().paused = false # Optional: unpause game

func toggle() -> void:
	if visible:
		close()
	else:
		open()

func _on_tab_selected(tab_name: String) -> void:
	current_tab_name = tab_name
	_update_tab_styles()
	
	# 清除当前显示的内容
	if current_page:
		current_page.queue_free()
		current_page = null
	
	# 隐藏默认的 Label
	if content_label:
		content_label.hide()

	# 根据 tab_name 实例化对应的场景
	var scene_to_load: PackedScene
	match tab_name:
		"Overview":
			scene_to_load = OVERVIEW_PAGE_SCENE
		"Inventory":
			scene_to_load = INVENTORY_PAGE_SCENE
		"Saves":
			scene_to_load = SAVES_PAGE_SCENE
		"Settings":
			scene_to_load = SETTINGS_PAGE_SCENE
	
	if scene_to_load:
		var page_instance = scene_to_load.instantiate()
		content_container.add_child(page_instance)
		current_page = page_instance
