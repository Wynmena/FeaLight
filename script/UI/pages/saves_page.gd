class_name SavesPage extends Control

const SAVE_SLOT_SCENE = preload("res://tscn/UI/pages/save_slot.tscn")
const TEST_DATA_PATH = "res://art/data/test_data/saves_test.json"

@onready var save_list_container: VBoxContainer = %SaveList

func _ready() -> void:
	_apply_theme()
	load_saves()

func _apply_theme() -> void:
	if has_node("ColorRect"):
		$ColorRect.color = GameTheme.COLOR_PANEL_BG

func load_saves() -> void:
	# Clear existing
	for child in save_list_container.get_children():
		child.queue_free()
		
	var saves_data = []
	
	# Load JSON
	if FileAccess.file_exists(TEST_DATA_PATH):
		var file = FileAccess.open(TEST_DATA_PATH, FileAccess.READ)
		var content = file.get_as_text()
		var json = JSON.new()
		if json.parse(content) == OK:
			if typeof(json.data) == TYPE_ARRAY:
				saves_data = json.data
			else:
				push_error("Saves data root is not an array")
		else:
			push_error("Failed to parse saves json")
	else:
		push_warning("Saves test file not found")
		
	# Populate list
	for i in range(saves_data.size()):
		var data = saves_data[i]
		add_slot(data, i)
		
	# Add an empty slot at the end
	add_slot({}, saves_data.size())

func add_slot(data: Dictionary, index: int) -> void:
	var slot = SAVE_SLOT_SCENE.instantiate()
	save_list_container.add_child(slot)
	
	# Setup data
	# We pass the dictionary and index.
	# The slot handles displaying "Empty Slot" logic if data is empty.
	slot.setup(data, index)
	
	# Connect signals
	slot.save_requested.connect(_on_save_requested)
	slot.load_requested.connect(_on_load_requested)

func _on_save_requested(slot_id: int) -> void:
	print("Save requested for slot: ", slot_id)
	# TODO: Implement actual save logic

func _on_load_requested(slot_id: int) -> void:
	print("Load requested for slot: ", slot_id)
	# TODO: Implement actual load logic
