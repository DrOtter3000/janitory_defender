extends Node3D


var player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _process(delta: float) -> void:
	player.update_building_status()
	if Gamestate.door_health <= 0:
		queue_free()


func _on_attack_range_body_entered(body: Node3D) -> void:
	if body is Enemy:
		body.in_door_range = true


func _on_attack_range_body_exited(body: Node3D) -> void:
	if body is Enemy:
		body.in_door_range = false
