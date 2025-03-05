extends Node2D
class_name Interior 

func _on_exit_area_body_entered(player: Player) -> void:
	LevelManager.change_location(load("uid://dw8dub4gaiyrp"), $Spawn.global_position)
