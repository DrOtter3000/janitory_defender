extends Area3D


var size_reducer := 0.01
var about_to_die := false
var collectable := true


func _process(delta: float) -> void:
	if about_to_die:
		die()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.scrap += 5
		$AnimationPlayer.play("Collected")


func _on_life_timer_timeout() -> void:
	about_to_die = true


func die() -> void:
	scale -= Vector3(size_reducer, size_reducer, size_reducer)
	if scale < Vector3.ZERO:
		queue_free()


func play_sound() -> void:
	$AudioStreamPlayer.play()


func set_as_collected():
	collectable = false
