extends Node

# Event Bus (Signal Bus)
# Centralizes communication between decoupled systems

# Map and Teleportation
signal request_change_map(map_name: String, tele_id: int)

# Save and Load
signal load_game_completed

