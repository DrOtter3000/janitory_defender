extends Control


func game_over() -> void:
	get_tree().paused = true
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_btn_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_btn_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")
