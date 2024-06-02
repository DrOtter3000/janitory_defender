extends CharacterBody3D


@export var speed := 7
@export var jump_height: float = 1.0
@export var fall_multiplier: float = 2.5
@export var max_hitpoints := 100
@export var aim_multiplier := 0.7

@onready var ammo_handler: AmmoHandler = %AmmoHandler
@onready var smooth_camera: Camera3D = %SmoothCamera
@onready var smooth_camera_fov := smooth_camera.fov
@onready var weapon_camera: Camera3D = %WeaponCamera
@onready var weapon_camera_fov := weapon_camera.fov
@onready var lbl_health: Label = $MarginContainer/VBoxContainer/Lbl_Health
@onready var healthbar: TextureProgressBar = $MarginContainer/VBoxContainer/Healthbar
@onready var lbl_scrap: Label = $MarginContainer/VBoxContainer/Lbl_Scrap
@onready var lbl_building_status: Label = $MarginContainer/VBoxContainer2/Lbl_BuildingStatus
@onready var lbl_countdown: Label = $MarginContainer/VBoxContainer2/Lbl_Countdown


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var respawn_position: Vector3
var mouse_motion := Vector2.ZERO
var teleport_status := 0.0
var scrap: int = 0:
	set(value):
		scrap = value
		lbl_scrap.text = str("Scrap: " + str(scrap))
var hitpoints: int = max_hitpoints:
	set(value):
		if value < hitpoints and hitpoints <= max_hitpoints:
			damage_animation_player.stop()
			damage_animation_player.play("TakeDamage")
		hitpoints = value
		lbl_health.text = str(str(value) + " / " + str(max_hitpoints))
		healthbar.value = value


@onready var game_over_menu: Control = $GameOverMenu
@onready var camera_pivot: Node3D = $CameraPivot
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer
var max_health_door := 0


func _ready() -> void:
	ammo_handler.restock_ammo()
	lbl_health.text = str(str(max_hitpoints) + " / " + str(max_hitpoints))
	healthbar.value = max_hitpoints
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	respawn_position = get_tree().get_first_node_in_group("respawn_position").global_position
	global_position = respawn_position
	update_building_status()


func _process(delta: float) -> void:
	if hitpoints > max_hitpoints:
		hitpoints = max_hitpoints
	
	if hitpoints < 0:
		die()
	
	if Input.is_action_pressed("aim"):
		smooth_camera.fov = lerp(smooth_camera.fov, 
		smooth_camera_fov * aim_multiplier, 
		delta * 20.0
		)
		weapon_camera.fov = lerp(weapon_camera.fov, 
		weapon_camera_fov * aim_multiplier,
		delta * 20.0
		)
	else:
		smooth_camera.fov = lerp(smooth_camera.fov, 
		smooth_camera_fov,
		delta * 30.0
		)
		weapon_camera.fov = lerp(weapon_camera.fov, 
		weapon_camera_fov,
		delta * 30.0
		)
	
	check_for_teleport()


func _physics_process(delta) -> void:
	# Allows player to turn
	handle_camera_rotation()
	
	# Add the gravity.
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = sqrt(jump_height * 2.0 * gravity)
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if Input.is_action_pressed("aim"):
			velocity.x *= aim_multiplier
			velocity.z *= aim_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func _input(event) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_motion = -event.relative * 0.001
	if event.is_action_pressed("pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func handle_camera_rotation() -> void:
	rotate_y(mouse_motion.x)
	camera_pivot.rotate_x(mouse_motion.y)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x, -90.0, 90.0
	)
	mouse_motion = Vector2.ZERO


func check_for_teleport() -> void:
	if Input.is_action_pressed("teleport"):
		teleport_status += 1
		print(teleport_status)
	else:
		teleport_status = 0
	if teleport_status == 100:
		global_position = respawn_position


func update_building_status() -> void:
	if Gamestate.door_health > 0:
		lbl_building_status.text = str("Status Door: " + 
		str(Gamestate.door_health) + " / " + str(Gamestate.max_door_health))
	else:
		lbl_building_status.text = str("Status Generator: " + str(Gamestate.generator_health) + " / " + str(Gamestate.max_generator_health))
 

func game_over() -> void:
	game_over_menu.game_over()


func die() -> void:
	hitpoints = 1
	global_position = respawn_position


func update_countdown(value: String) -> void:
	lbl_countdown.text = value

