extends Node

signal property_changed(property: String, new_value: int)

var max_health: int = 10:
	set(new_value):
		if max_health != new_value:
			if new_value < 0:
				new_value = 0
			max_health = new_value
			if health > max_health:
				health = max_health
			property_changed.emit("max_health", max_health)

var health: int = max_health:
	set(new_value):
		if health != new_value:
			if new_value > max_health:
				new_value = max_health
			if new_value < 0:
				new_value = 0
			health = new_value
			property_changed.emit("health", health)
			
var keys: int = 0:
	set(new_value):
		if keys != new_value:
			keys = new_value
			property_changed.emit("keys", keys)

func _ready() -> void:
	GameEvent.game_reloaded.connect(_on_game_reloaded)

func _on_game_reloaded():
	reset_all()

func reset_all():
	max_health = 10
	health = max_health
	keys = 0

func has_hey() -> bool:
	return keys > 0
