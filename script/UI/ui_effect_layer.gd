class_name UIEffectLayer extends CanvasLayer


# 外部调用函数时，使用 enum 可避免 String 拼写错误导致的 bug
enum AnimType{
	BLACK_SCREEN,
}

var _anim_type_name: Dictionary[AnimType, String] = {
	AnimType.BLACK_SCREEN : "black_screen",
}


@onready var anim: AnimationPlayer = $AnimationPlayer


func is_playing(anim_name: String) -> bool:
	return anim.is_playing() and anim.current_animation == anim_name


func has_animation(anim_name: String) -> bool:
	return anim.has_animation(anim_name)


func play(anim_type: AnimType) -> void:
	_play_anim(_anim_type_name[anim_type], false)

func play_backwards(anim_type: AnimType) -> void:
	_play_anim(_anim_type_name[anim_type], true)

func _play_anim(anim_name: String, is_backwards: bool) -> void:
	if not has_animation(anim_name):
		push_warning("try play unexited animation: ", anim_name)
		return
	
	if is_backwards :
		anim.play_backwards(anim_name)
		await anim.animation_finished
		SignalBus.ui_eff_anim_backward_finished.emit(anim_name)
	else:
		anim.play(anim_name)
		await anim.animation_finished
		SignalBus.ui_eff_anim_forward_finished.emit(anim_name)
		
	SignalBus.ui_eff_anim_finished.emit(anim_name)
