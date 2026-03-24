class_name NoticeBoard extends Node2D


@onready var interaction_component: InteractionComponent = $InteractionComponent
@onready var enter_lab: Label = $EnterLabel
@onready var contect_lab: Label = $ContectLabel


@export var _just_show_contect: bool = true
@export var enter_text: String = "no enter text"
@export var contect: String = "no contect"


var _player_is_here: bool = false


func _ready() -> void:
	if interaction_component:
		interaction_component.interact_start.connect(_on_interaction_start)
		interaction_component.interact_end.connect(_on_interaction_end)
		
	enter_lab.text = enter_text
	contect_lab.text = contect
	enter_lab.hide()
	contect_lab.hide()


func _on_interaction_start() -> void:
	_player_is_here = true
	contect_lab.show() if _just_show_contect else enter_lab.show()


func _on_interaction_end() -> void:
	_player_is_here = false
	enter_lab.hide()
	contect_lab.hide()


func _unhandled_input(event: InputEvent) -> void:
	if _player_is_here and not contect_lab.visible\
	 and event is InputEventKey and event.pressed:
		var new_event = event as InputEventKey
		if (new_event.keycode):
			enter_lab.hide()
			contect_lab.show()
