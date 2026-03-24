class_name SaveSlot extends PanelContainer

signal save_requested(slot_id)
signal load_requested(slot_path)

var _save_data: Dictionary = {}
var _slot_id: int = -1

@onready var icon_texture: TextureRect = %Icon
@onready var name_label: Label = %NameLabel
@onready var location_label: Label = %LocationLabel
@onready var time_label: Label = %TimeLabel
@onready var save_btn: Button = %SaveButton
@onready var load_btn: Button = %LoadButton

func _ready() -> void:
	if GameManager:
		load_requested.connect(GameManager._on_load_requested)

func setup(data: Dictionary, id: int) -> void:
	_save_data = data
	_slot_id = id
	
	if data.is_empty():
		# "Empty Slot" behavior
		name_label.text = "Empty Slot"
		location_label.text = "-"
		time_label.text = "-"
		# icon_texture.texture = null # Keep placeholder or set null
		load_btn.disabled = true
	else:
		name_label.text = data.get("name", "Unknown Save")
		location_label.text = data.get("location", "Unknown Location")
		time_label.text = data.get("time", "")
		
		var icon_path = data.get("icon", "")
		if icon_path and ResourceLoader.exists(icon_path):
			icon_texture.texture = load(icon_path)
		else:
			# Fallback for missing icon
			pass 
			
		load_btn.disabled = false
		
	save_btn.pressed.connect(func(): save_requested.emit(_slot_id))
	load_btn.pressed.connect(func(): load_requested.emit(_save_data["path"] if _save_data.has("path") else ""))

	_apply_theme()

func _apply_theme() -> void:
	# 尝试应用全局主题
	if GameTheme:
		var style = GameTheme.get_style_box_flat(GameTheme.COLOR_PANEL_BG, 5, 1, GameTheme.COLOR_PRIMARY)
		add_theme_stylebox_override("panel", style)
		
		GameTheme.apply_button_theme(save_btn)
		GameTheme.apply_button_theme(load_btn)
		
		name_label.add_theme_color_override("font_color", GameTheme.COLOR_TEXT_HIGHLIGHT)
		location_label.add_theme_color_override("font_color", GameTheme.COLOR_TEXT_PRIMARY)
		time_label.add_theme_color_override("font_color", GameTheme.COLOR_TEXT_SECONDARY)
