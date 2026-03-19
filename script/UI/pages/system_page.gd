class_name SystemPage extends Control

@onready var bgm_slider: HSlider = %BGMSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var amb_slider: HSlider = %AmbSlider

@onready var brightness_slider: HSlider = %BrightnessSlider
@onready var fps_option_btn: OptionButton = %FPSOptionBtn

func _ready() -> void:
	_apply_theme()
	_init_fps_options()
	
	# Connect signals
	if bgm_slider: bgm_slider.value_changed.connect(_on_bgm_value_changed)
	if sfx_slider: sfx_slider.value_changed.connect(_on_sfx_value_changed)
	if amb_slider: amb_slider.value_changed.connect(_on_amb_value_changed)
	if brightness_slider: brightness_slider.value_changed.connect(_on_brightness_value_changed)
	if fps_option_btn: fps_option_btn.item_selected.connect(_on_fps_selected)
	
	# TODO: Load initial volume values from AudioServer or Settings Manager

func _init_fps_options() -> void:
	if not fps_option_btn: return
	fps_option_btn.add_item("30 FPS", 30)
	fps_option_btn.add_item("60 FPS", 60)
	fps_option_btn.add_item("120 FPS", 120)
	fps_option_btn.add_item("Unlimited", 0)
	fps_option_btn.select(1) # Default to 60 FPS

func _apply_theme() -> void:
	if has_node("ColorRect"):
		$ColorRect.color = GameTheme.COLOR_PANEL_BG
	
	# Theme for titles (highlight)
	var titles = [
		%AudioTitle, %GraphicsTitle, %ControlsTitle
	]
	for lbl in titles:
		if lbl: lbl.add_theme_color_override("font_color", GameTheme.COLOR_TEXT_HIGHLIGHT)

	# Theme for normal labels and body text
	var labels = [
		%BGMLabel, %SFXLabel, %AmbLabel, %BrightnessLabel, %FPSLabel, %ControlsBody
	]
	for lbl in labels:
		if lbl: lbl.add_theme_color_override("font_color", GameTheme.COLOR_TEXT_PRIMARY)

	# Theme for Section Panels
	var sections = [
		%AudioSection, %GraphicsSection, %ControlsSection
	]
	# Use Primary color for section borders to look like ink/frame
	var section_style = GameTheme.get_style_box_flat(Color.TRANSPARENT, 5, 1, GameTheme.COLOR_PRIMARY)
	# Add some padding to the content inside the border
	section_style.content_margin_left = 20
	section_style.content_margin_right = 20
	section_style.content_margin_top = 10
	section_style.content_margin_bottom = 10
	
	for sec in sections:
		if sec: sec.add_theme_stylebox_override("panel", section_style)

	# OptionButton Style
	if fps_option_btn:
		GameTheme.apply_button_theme(fps_option_btn)

	# Slider Styles
	var sliders = [bgm_slider, sfx_slider, amb_slider, brightness_slider]
	
	var slider_track = GameTheme.get_style_box_flat(GameTheme.BTN_COLOR_NORMAL, 4)
	var slider_fill = GameTheme.get_style_box_flat(GameTheme.COLOR_ACCENT, 4)
	var slider_fill_hl = GameTheme.get_style_box_flat(GameTheme.COLOR_SECONDARY, 4)
	
	for s in sliders:
		if s:
			s.add_theme_stylebox_override("slider", slider_track)
			s.add_theme_stylebox_override("grabber_area", slider_fill)
			s.add_theme_stylebox_override("grabber_area_highlight", slider_fill_hl)

func _on_bgm_value_changed(value: float) -> void:
	print("BGM Volume: ", value)
	# TODO: Set AudioServer db

func _on_sfx_value_changed(value: float) -> void:
	print("SFX Volume: ", value)
	# TODO: Set AudioServer db

func _on_amb_value_changed(value: float) -> void:
	print("Ambience Volume: ", value)
	# TODO: Set AudioServer db

func _on_brightness_value_changed(value: float) -> void:
	print("Brightness: ", value)
	# TODO: Set WorldEnvironment adjustments

func _on_fps_selected(index: int) -> void:
	var fps = fps_option_btn.get_item_id(index)
	print("Max FPS Set to: ", fps)
	if fps > 0:
		Engine.max_fps = fps
	else:
		Engine.max_fps = 0 # Unlimited
