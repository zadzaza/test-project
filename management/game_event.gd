extends Node

signal player_position_changed(pos: Vector2)
signal location_changed(location: Node2D)
signal alarm_activated
signal game_reloaded

var is_alarm_activated: bool = false

func _ready() -> void:
	location_changed.connect(_on_location_changed)

func quit():
	get_tree().quit()

func reload_game():
	is_alarm_activated = false
	game_reloaded.emit()
	#await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://game/main/main.tscn")

func alarm_activate():
	is_alarm_activated = true
	if get_tree().current_scene is MainScene:
		alarm_activated.emit()
		is_alarm_activated = false

func _on_location_changed(location: Node2D):
	if is_alarm_activated:
		if location is MainScene:
			alarm_activated.emit()
			is_alarm_activated = false
