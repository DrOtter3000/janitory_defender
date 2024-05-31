extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gamestate.score = 0
	Gamestate.door_health = Gamestate.max_door_health
	Gamestate.generator_health = Gamestate.max_generator_health
