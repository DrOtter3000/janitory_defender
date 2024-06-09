extends Control


func _on_btn_new_game_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")


func _on_btn_quit_pressed() -> void:
	get_tree().quit()
