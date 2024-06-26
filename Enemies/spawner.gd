extends Node3D


@export var enemy: PackedScene
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	Gamestate.enemy_target += 5 + Gamestate.wave


func spawn_enemy() -> void:
	var new_enemy = enemy.instantiate()
	get_node("..").add_child(new_enemy)
	new_enemy.global_position = position + Vector3(randi_range(-10, 10),0,0)


func _on_enemy_spawn_timer_timeout() -> void:
	if Gamestate.enemies_on_field < Gamestate.enemy_target:
		spawn_enemy()
		enemy_spawn_timer.start()
		Gamestate.enemies_on_field += 1
	else:
		animation_player.play("fly_away")


func drop_enemies() -> void:
	enemy_spawn_timer.start()


func exited() -> void:
	Gamestate.drop_finished = true
