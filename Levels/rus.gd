extends Node3D


@onready var ammotimer: Timer = $Ammotimer
@export var bullets: AmmoHandler.ammo_type
@export var small_bullets: AmmoHandler.ammo_type
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_reload_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		ammotimer.wait_time = 1.0
		ammotimer.start()


func _on_ammotimer_timeout() -> void:
	player.ammo_handler.add_ammo(bullets, 5)
	player.ammo_handler.add_ammo(small_bullets, 50)
	player.hitpoints += 50
	ammotimer.start()


func _on_reload_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		ammotimer.stop()
