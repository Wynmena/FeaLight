extends Node


func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_ESCAPE:
            # 将菜单逻辑委托给 SceneManager
            if SceneManager.has_method("toggle_menu"):
                SceneManager.toggle_menu()