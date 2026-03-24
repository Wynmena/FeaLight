class_name GameData
extends RefCounted

var current_zone: String = ""
var player_pos: Vector2 = Vector2.ZERO
var inventory_items: Dictionary = {} # Dictionary: { item_id: int, count: int }

static func load_from_json(file_path: String) -> GameData:
	if not FileAccess.file_exists(file_path):
		push_error("File not found: " + file_path)
		return null
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_text = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(json_text)
	
	if error != OK:
		push_error("JSON Parse Error: " + json.get_error_message())
		return null
		
	var data = json.get_data()
	var new_game_data = GameData.new()
	
	if data.has("position"):
		var pos_data = data["position"]
		new_game_data.current_zone = pos_data.get("zone", "")
		var coords = pos_data.get("coordinates", [0, 0])
		if coords is Array and coords.size() >= 2:
			new_game_data.player_pos = Vector2(coords[0], coords[1])
		
	if data.has("game_data") and data["game_data"].has("inventory"):
		var inv_data = data["game_data"]["inventory"]
		if inv_data is Array:
			for item in inv_data:
				if item.has("item_id") and item.has("count"):
					new_game_data.inventory_items[int(item["item_id"])] = int(item["count"])
			
	return new_game_data
