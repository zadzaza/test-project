extends Node2D
class_name MainScene

signal scene_ready

@onready var player: Player

func _ready():
	await get_tree().process_frame
	scene_ready.emit()
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if player:
		player.global_position.x = clamp(player.global_position.x, 0, get_viewport_rect().size.x)
		player.global_position.y = clamp(player.global_position.y, 0, get_viewport_rect().size.y)
	
