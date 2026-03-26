extends Node

# Event Bus (Signal Bus)
# Centralizes communication between decoupled systems

# Map and Teleportation
signal request_change_map(map_name: String, tele_id: int)

# Save and Load
signal load_game_completed

# ui_effect_layer调用
signal ui_eff_anim_forward_finished(anim_name: String)
signal ui_eff_anim_backward_finished(anim_name: String)
signal ui_eff_anim_finished(anim_name: String)
