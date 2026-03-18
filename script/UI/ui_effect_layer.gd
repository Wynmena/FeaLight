class_name UIEffectLayer extends CanvasLayer


signal anim_forward_finish
signal anim_backward_finish
signal anim_finish

@onready var anim: AnimationPlayer = $AnimationPlayer


func is_playing(anim_name: String) -> bool:
	return anim.is_playing() and anim.current_animation == anim_name


func has_animation(anim_name: String) -> bool:
	return anim.has_animation(anim_name)


func play_black_screen(back_signal: Signal) -> void:
	_play_anim("black_screen", true, back_signal)


func _play_anim(anim_name: String, play_backward: bool = false, back_signal:Signal = Signal()) -> void:
	if not has_animation(anim_name):
		push_warning("try play unexited animation: ", anim_name)
		return
	anim.play(anim_name)
	await anim.animation_finished
	anim_forward_finish.emit()
	if not play_backward:
		return
	if not back_signal == Signal():
		print("back_signal is not null")
		await back_signal
	print("play backward")
	anim.play_backwards(anim_name)
	anim_backward_finish.emit()
	anim_finish.emit()
