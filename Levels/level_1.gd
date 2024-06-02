extends Node3D


@export var enemy_spawner: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Gamestate.score = 0
	Gamestate.door_health = Gamestate.max_door_health
	Gamestate.generator_health = Gamestate.max_generator_health
	start_wave()


func _process(delta: float) -> void:
	pass

func start_spawner(pos_x: int, pos_z: int) -> void:
	var spawner = enemy_spawner.instantiate()
	add_child(spawner)
	spawner.global_position = Vector3(0, 6, pos_z)


func start_wave() -> void:
	match Gamestate.wave:
		1:
			start_spawner(0, 300)
			
		2:
			start_spawner(100, 300)
			start_spawner(-100, 300)
			
		_:
			start_spawner(0, 300)
			start_spawner(100, 300)
			start_spawner(-100, 300)
		
