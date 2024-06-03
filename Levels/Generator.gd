extends Node3D


var player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	player.update_building_status()
	if Gamestate.generator_health <= 0:
		player.game_over()
		queue_free()


func _on_attack_area_body_entered(body: Node3D) -> void:
	if body is Enemy:
		body.in_generator_range = true


func _on_attack_area_body_exited(body: Node3D) -> void:
	if body is Enemy:
		body.in_generator_range = false
