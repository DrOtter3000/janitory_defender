extends Control


var player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("upgrade"):
		visible != visible
		


func _on_btn_back_pressed() -> void:
	Input.mouse_mode =Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	visible = false


func _on_btn_health_pressed() -> void:
	if player.scrap >= 100:
		player.scrap -= 100
		player.max_hitpoints += 10
		player.upgrade_labels()
		upgrade_scrap()


func _on_btn_speed_pressed() -> void:
	if player.scrap >= 500:
		player.scrap -= 500
		player.speed += 1
		player.upgrade_labels()
		upgrade_scrap()


func upgrade_scrap():
	$TextureRect/CenterContainer/VBoxContainer/Lbl_Scrap.text = str("Scrap: " + str(player.scrap))


