class_name GameTheme extends RefCounted

# --- 颜色定义 ---
const COLOR_PRIMARY = Color("5e60ce")       # 主色调 (紫色系示例)
const COLOR_SECONDARY = Color("4ea8de")     # 次色调 (蓝色系示例)
const COLOR_ACCENT = Color("80ffdb")        # 强调色
const COLOR_BACKGROUND = Color("1e1e2e")    # 通用背景黑
const COLOR_PANEL_BG = Color(0.1, 0.1, 0.1, 0.8) # 面板半透明背景

const COLOR_TEXT_PRIMARY = Color.WHITE
const COLOR_TEXT_SECONDARY = Color(0.7, 0.7, 0.7, 1.0)
const COLOR_TEXT_HIGHLIGHT = Color("ffba08")

# --- 按钮样式配置 ---
# 正常状态颜色
const BTN_COLOR_NORMAL = Color("2b2d42")
# 悬停状态颜色
const BTN_COLOR_HOVER = Color("3d405b")
# 按下状态颜色
const BTN_COLOR_PRESSED = Color("1d1f30")
# 选中状态颜色 (Tab)
const BTN_COLOR_SELECTED = Color("5e60ce") 
# 禁用状态颜色
const BTN_COLOR_DISABLED = Color("1a1a1a")

# 边框颜色
const BTN_BORDER_COLOR = Color("8d99ae")

# --- 样式生成工具 ---

static func get_style_box_flat(bg_color: Color, corner_radius: int = 5, border_width: int = 0, border_color: Color = Color.TRANSPARENT) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = bg_color
	style.corner_radius_top_left = corner_radius
	style.corner_radius_top_right = corner_radius
	style.corner_radius_bottom_right = corner_radius
	style.corner_radius_bottom_left = corner_radius
	
	if border_width > 0:
		style.border_width_left = border_width
		style.border_width_top = border_width
		style.border_width_right = border_width
		style.border_width_bottom = border_width
		style.border_color = border_color
		
	# 内边距
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 5
	style.content_margin_bottom = 5
	
	return style

# 快速应用到按钮
static func apply_button_theme(btn: Button) -> void:
	btn.add_theme_color_override("font_color", COLOR_TEXT_PRIMARY)
	btn.add_theme_color_override("font_hover_color", COLOR_ACCENT)
	
	btn.add_theme_stylebox_override("normal", get_style_box_flat(BTN_COLOR_NORMAL))
	btn.add_theme_stylebox_override("hover", get_style_box_flat(BTN_COLOR_HOVER, 5, 1, BTN_BORDER_COLOR))
	btn.add_theme_stylebox_override("pressed", get_style_box_flat(BTN_COLOR_PRESSED))
	btn.add_theme_stylebox_override("disabled", get_style_box_flat(BTN_COLOR_DISABLED))
