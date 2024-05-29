extends Node3D


func _process(delta: float) -> void:
	if Gamestate.door_health <= 0:
		print("defect")
		queue_free()
