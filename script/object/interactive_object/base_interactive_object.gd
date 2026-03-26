class_name BaseInteractiveObject extends Node2D


func close_all_interaction_component() -> void:
	for comp: InteractionComponent in \
	get_children().filter(func(child): return child is InteractionComponent):
		comp.close_collision()


func open_all_interaction_component() -> void:
	for comp: InteractionComponent in \
	get_children().filter(func(child): return child is InteractionComponent):
		comp.open_collision()
