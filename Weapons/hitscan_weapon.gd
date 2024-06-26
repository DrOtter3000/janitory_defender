extends Node3D


@export var fire_rate := 14.0
@export var recoil := 0.05
@export var weapon_mesh: Node3D
@export var weapon_damage := 15
@export var muzzle_flash: GPUParticles3D
@export var sparks: PackedScene
@export var automatic: bool 
@export var ammo_handler: AmmoHandler
@export var ammo_type: AmmoHandler.ammo_type
@export var fire_sound: String

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_position: Vector3 = weapon_mesh.position
@onready var ray_cast_3d: RayCast3D = $RayCast3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if automatic:
		if Input.is_action_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
		if visible:
			$RayCast3D.target_position.z = -100
	else:
		if Input.is_action_just_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
		if visible:
			$RayCast3D.target_position.z = -1000

	weapon_mesh.position = weapon_mesh.position.lerp(weapon_position, delta * 10.0)


func shoot() -> void:
	if ammo_handler.has_ammo(ammo_type):
		ammo_handler.use_ammo(ammo_type)
		cooldown_timer.start(1.0/fire_rate)
		
		muzzle_flash.restart()
		weapon_mesh.position.z += recoil
		
		var collider = ray_cast_3d.get_collider()
		if collider is Enemy:
			collider.hitpoints -= weapon_damage
		var spark = sparks.instantiate()
		if ray_cast_3d.is_colliding():
			add_child(spark)
			spark.global_position = ray_cast_3d.get_collision_point()
		
		$AudioStreamPlayer.stream = load(fire_sound)
		$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1.1)
		$AudioStreamPlayer.play()
