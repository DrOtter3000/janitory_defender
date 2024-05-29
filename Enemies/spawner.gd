extends Node3D


@export var enemy: PackedScene
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer


func _ready() -> void:
	enemy_spawn_timer.start()

func spawn_enemy() -> void:
	var new_enemy = enemy.instantiate()
	add_child(new_enemy)
	new_enemy.position = Vector3(randi_range(-10, 10),0,0)


func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()
	enemy_spawn_timer.start()
