extends Node


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            # 将菜单逻辑委托给 ScreenManager
            if ScreenManager.has_method("toggle_menu"):
                ScreenManager.toggle_menu()