extends Node3D


@export var enemy_spawner: PackedScene
@onready var next_wave_timer: Timer = $NextWaveTimer
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	Gamestate.score = 0
	Gamestate.door_health = Gamestate.max_door_health
	Gamestate.generator_health = Gamestate.max_generator_health
	start_wave()


func _process(delta: float) -> void:
	if Gamestate.enemies_killed == Gamestate.enemy_target:
		prepare_for_next_level()


func start_spawner(pos_x: int, pos_z: int) -> void:
	var spawner = enemy_spawner.instantiate()
	add_child(spawner)
	spawner.global_position = Vector3(pos_x, 6, pos_z)


func start_wave() -> void:
	player.update_countdown(str(""))
	Gamestate.drop_finished = false
	match Gamestate.wave:
		1:
			start_spawner(0, 150)
			
		2:
			start_spawner(100, 150)
			start_spawner(-100, 150)
			
		_:
			start_spawner(0, 150)
			start_spawner(100, 150)
			start_spawner(-100, 150)


func prepare_for_next_level() -> void:
	if Gamestate.wave < 10:
		if next_wave_timer.is_stopped():
			next_wave_timer.start()
		else:
			player.update_countdown(str("Next Wave starts in: " + str(int(next_wave_timer.time_left)) + " seconds"))
	else:
		print("Winner")


func _on_next_wave_timer_timeout() -> void:
	Gamestate.wave += 1
	Gamestate.enemies_killed = 0
	Gamestate.enemies_on_field = 0
	Gamestate.enemy_target = 0
	start_wave()
