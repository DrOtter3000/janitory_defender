extends Node3D


@onready var ammotimer: Timer = $Ammotimer
@export var bullets: AmmoHandler.ammo_type
@export var small_bullets: AmmoHandler.ammo_type
@onready var healthtimer: Timer = $Healthtimer
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _on_reload_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		ammotimer.start()
		healthtimer.start()


func _on_ammotimer_timeout() -> void:
	player.ammo_handler.add_ammo(bullets, 3)
	player.ammo_handler.add_ammo(small_bullets, 10)
	ammotimer.start()


func _on_reload_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		ammotimer.stop()
		healthtimer.stop()


func _on_healthtimer_timeout() -> void:
	player.hitpoints += 1
	healthtimer.start()
