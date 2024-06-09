extends Control


var player
@onready var slider_sensetivity: HSlider = $CenterContainer/VBoxContainer/SliderSensetivity


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _on_btn_back_pressed() -> void:
	player.quit_pause(slider_sensetivity.value)
	Input.mouse_mode =Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	visible = false

