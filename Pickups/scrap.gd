extends Area3D


@export var ammo_type: AmmoHandler.ammo_type
@export var amount: int = 20

var size_reducer := 0.01
var about_to_die := false


func _process(delta: float) -> void:
	if about_to_die:
		print("ouchie")
		die()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.scrap += 5
		queue_free()


func _on_life_timer_timeout() -> void:
	about_to_die = true


func die() -> void:
	scale -= Vector3(size_reducer, size_reducer, size_reducer)
	if scale < Vector3.ZERO:
		queue_free()
