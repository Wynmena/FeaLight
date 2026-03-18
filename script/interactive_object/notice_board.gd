class_name NoticeBoard extends InteractiveObject


@onready var Enter_lab: Label = $EnterLabel
@onready var contect_lab: Label = $ContectLabel


@export var _just_show_contect: bool = true
@export var enter_text: String = "no enter text"
@export var contect: String = "no contect"


var _player_is_here: bool = false


func _ready() -> void:
	Enter_lab.text = enter_text
	contect_lab.text = contect
	Enter_lab.hide()
	contect_lab.hide()


func _player_enter_reaction() -> void:
	_player_is_here = true
	contect_lab.show() if _just_show_contect else Enter_lab.show()


func _player_exited_reaction() -> void:
	_player_is_here = false
	Enter_lab.hide()
	contect_lab.hide()


func _unhandled_input(event: InputEvent) -> void:
	if _player_is_here and not contect_lab.visible\
	 and event is InputEventKey and event.pressed:
		var new_event = event as InputEventKey
		if (new_event.keycode):
			Enter_lab.hide()
			contect_lab.show()
