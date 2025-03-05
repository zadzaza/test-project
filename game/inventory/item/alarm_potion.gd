extends Item

func _on_used():
	GameEvent.alarm_activate()
