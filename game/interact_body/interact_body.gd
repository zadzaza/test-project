extends StaticBody2D
class_name InteractBody

var in_interact_area: bool = false

func interact(player: Player = null):
	pass

func _on_area_2d_body_entered(player: Player) -> void:
	in_interact_area = true

func _on_area_2d_body_exited(player: Player) -> void:
	in_interact_area = false

func _on_tree_exited() -> void:
	owner = null
