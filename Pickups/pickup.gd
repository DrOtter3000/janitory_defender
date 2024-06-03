extends Area3D


@export var ammo_type: AmmoHandler.ammo_type
@export var amount: int = 20
@export var collect_sound: String

var collectable := true
var size_reducer := 0.01
var about_to_die := false


func _process(delta: float) -> void:
	if about_to_die:
		die()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and collectable:
		body.ammo_handler.add_ammo(ammo_type, amount)
		$AnimationPlayer.play("collected")


func set_as_collected():
	collectable = false

func _on_life_timer_timeout() -> void:
	about_to_die = true


func die() -> void:
	scale -= Vector3(size_reducer, size_reducer, size_reducer)
	if scale < Vector3.ZERO:
		queue_free()


func play_sound() -> void:
	$AudioStreamPlayer.stream = load(collect_sound)
	$AudioStreamPlayer.pitch_scale = randf_range(0.9, 1.1)
	$AudioStreamPlayer.play()
