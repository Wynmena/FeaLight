class_name InventoryPage extends Control

@onready var grid_container: GridContainer = %ItemGrid
@onready var details_panel: PanelContainer = %DetailsPanel 
@onready var detail_icon: TextureRect = %DetailIcon
@onready var detail_name: Label = %DetailName
@onready var detail_desc: Label = %DetailDesc


const ITEM_DATA_PATH = "res://art/data/items.json"

var items_data = []

const COLS = 7
const MIN_ROWS = 5 # 至少显示几行

func _ready() -> void: # 初始化界面，加载数据并监听信号
	_apply_theme()
	load_items_data()
	
	# 监听大小变化以重新计算Item大小
	grid_container.columns = COLS
	grid_container.resized.connect(_on_grid_resized)
	
	populate_grid()
	
	# Default selection: first item if available
	if items_data.size() > 0:
		update_detail_view(items_data[0])
	else:
		clear_detail_view()

func _on_grid_resized() -> void: # 响应 Grid 大小变动，动态调整物品格尺寸
	# 动态调整 GridContainer 子项大小
	
	var total_width = grid_container.size.x
	var h_sep = grid_container.get_theme_constant("h_separation")
	var item_width = (total_width - (h_sep * (COLS ))) / COLS
	
	# 限制最小尺寸
	if item_width < 50: item_width = 50
	
	for child in grid_container.get_children():
		if child is Control:
			child.custom_minimum_size = Vector2(item_width, item_width)

func _apply_theme() -> void: # 应用全局主题样式到 UI 元素
	# 背景
	if has_node("ColorRect"):
		$ColorRect.color = GameTheme.COLOR_PANEL_BG
		
	if details_panel:
		var panel_style = GameTheme.get_style_box_flat(GameTheme.COLOR_PANEL_BG, 8, 2, GameTheme.COLOR_PRIMARY)
		panel_style.content_margin_top = 15
		panel_style.content_margin_bottom = 15
		panel_style.content_margin_left = 15
		panel_style.content_margin_right = 15
		
		details_panel.add_theme_stylebox_override("panel", panel_style)

	# 详情文本颜色
	if detail_name:
		detail_name.add_theme_color_override("font_color", GameTheme.COLOR_TEXT_HIGHLIGHT)
	if detail_desc:
		detail_desc.add_theme_color_override("font_color", GameTheme.COLOR_TEXT_SECONDARY)

	# 给 DetailIcon 添加背景
	if detail_icon:
		var parent = detail_icon.get_parent()
		if parent:
			var bg_node_name = "DetailIconBg"
			if not parent.has_node(bg_node_name):
				var p = Panel.new()
				p.name = bg_node_name
				p.custom_minimum_size = detail_icon.custom_minimum_size + Vector2(20, 20)
				
				var bg_color = GameTheme.COLOR_PRIMARY
				bg_color.a = 0.1
				var style = GameTheme.get_style_box_flat(bg_color, 5)
				
				p.add_theme_stylebox_override("panel", style)
				parent.add_child(p)
				parent.move_child(p, 0)

func load_items_data() -> void: # 从 JSON 文件加载物品数据
	if not FileAccess.file_exists(ITEM_DATA_PATH):
		push_error("Item data file not found: " + ITEM_DATA_PATH)
		return
		
	var file = FileAccess.open(ITEM_DATA_PATH, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(content)
	
	if error == OK:
		items_data = json.data
		if typeof(items_data) != TYPE_ARRAY:
			push_error("Unexpected data format in items.json")
			items_data = []
	else:
		push_error("JSON Parse Error: ", json.get_error_message(), " in ", content, " at line ", json.get_error_line())

func populate_grid() -> void: # 根据加载的数据和布局要求生成物品网格
	# Clear existing children
	for child in grid_container.get_children():
		child.queue_free()
		
	var h_sep = 10 # 默认间距
	if grid_container.has_theme_constant("h_separation"):
		h_sep = grid_container.get_theme_constant("h_separation")
	var total_width = grid_container.size.x
	
	# 算每一格的大小，防止除以0
	var item_width = 64.0
	if total_width > 0:
		item_width = (total_width - (h_sep * (COLS))) / COLS
		if item_width < 50: item_width = 50

	for item in items_data:
		var btn = _create_item_button(item, item_width)
		grid_container.add_child(btn)
		
	# 2. 补全空位直到满足最小行数 或 填满最后一行
	var total_items = items_data.size()
	var needed_slots = MIN_ROWS * COLS
	
	if total_items < needed_slots:
		for i in range(needed_slots - total_items):
			var empty_slot = _create_empty_slot(item_width)
			grid_container.add_child(empty_slot)

func _create_item_button(item: Dictionary, size: float) -> Button: # 创建单个物品按钮
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(size, size)
	btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	btn.expand_icon = true
	
	if item.has("icon"):
		var texture = load(item["icon"])
		if texture:
			btn.icon = texture
		else:
			btn.text = item["name"].left(1)
	
	GameTheme.apply_button_theme(btn)
	btn.pressed.connect(func(): update_detail_view(item))
	return btn

func _create_empty_slot(size: float) -> Panel: # 创建空槽位占位符
	var p = Panel.new()
	p.custom_minimum_size = Vector2(size, size)
	
	var bg_color = GameTheme.COLOR_PRIMARY
	bg_color.a = 0.1
	var style = GameTheme.get_style_box_flat(bg_color, 5)
	
	p.add_theme_stylebox_override("panel", style)
	return p

func update_detail_view(item: Dictionary) -> void: # 更新右侧物品详情面板显示
	detail_name.text = item.get("name", "Unknown Item")
	detail_desc.text = item.get("desc", "No description available.")
	
	if item.has("icon"):
		var texture = load(item["icon"])
		if texture:
			detail_icon.texture = texture
		else:
			detail_icon.texture = null
			
func clear_detail_view() -> void: # 清空物品详情面板
	detail_name.text = ""
	detail_desc.text = ""
	detail_icon.texture = null
