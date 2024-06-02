extends CharacterBody3D
class_name Enemy


const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed = 3.0
@export var aggro_range := 12.0
@export var attack_range := 1.5
@export var max_hitpoints := 100
@export var damage := 20
@export var scrap_pickup: PackedScene
@export var bullet_pickup: PackedScene
@export var small_bullet_pickup: PackedScene
@onready var player_detection_cast: RayCast3D = $PlayerDetectionCast
@onready var reset_timer: Timer = $ResetTimer




var player
var door
var generator

var provoked := false
var hitpoints: int = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			spawn_pickup()
			die()
		provoked = true


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	door = get_tree().get_first_node_in_group("door")
	generator = get_tree().get_first_node_in_group("generator")


func _process(delta: float) -> void:
	detect_player()
	if provoked:
		navigation_agent_3d.target_position = player.global_position
		if global_position.distance_to(player.global_position) <= attack_range:
			animation_player.play("Attack")
	else:
		if Gamestate.door_health > 0:
			navigation_agent_3d.target_position = door.global_position
			if global_position.distance_to(door.global_position) <= attack_range:
				animation_player.play("attack_door")
		else:
			navigation_agent_3d.target_position = generator.global_position
			if global_position.distance_to(generator.global_position) <= attack_range:
				animation_player.play("attack_generator")


func _physics_process(delta: float) -> void:
	var next_position = navigation_agent_3d.get_next_path_position()
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var direction = global_position.direction_to(next_position)
	var distance = global_position.distance_to(player.global_position)
	
	if distance <= aggro_range:
		provoked = true
	
	if direction:
		if is_on_floor():
			look_at_target(direction)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()


func look_at_target(direction: Vector3) -> void:
	var adjusted_direction = direction
	adjusted_direction.y = 0
	look_at(global_position + adjusted_direction, Vector3.UP, true)


func attack() -> void:
	player.hitpoints -= damage


func damage_building() -> void:
	if Gamestate.door_health > 0:
		Gamestate.door_health -= damage
	else:
		Gamestate.generator_health -= damage


func spawn_pickup():
	var pickup_selector = randi_range(1, 5)
	var pickup
	if pickup_selector == 1:
		pickup = bullet_pickup.instantiate()
	elif pickup_selector == 2:
		pickup = small_bullet_pickup.instantiate()
	else:
		pickup = scrap_pickup.instantiate()
	get_tree().get_root().add_child(pickup)
	pickup.global_position = global_position
	pickup.global_position.y -= 0.5


func die() -> void:
	Gamestate.enemies_killed += 1
	queue_free()


func detect_player() -> void:
	player_detection_cast.target_position = player.global_position
	if player_detection_cast.is_colliding():
		if not player_detection_cast.get_collider().is_in_group("player") and reset_timer.is_stopped():
			reset_timer.start()
		elif player_detection_cast.get_collider().is_in_group("player"):
			reset_timer.stop()
			reset_timer.wait_time = 5.0
			provoked = true
		


func _on_reset_timer_timeout() -> void:
	provoked = false
	reset_timer.wait_time = 5
