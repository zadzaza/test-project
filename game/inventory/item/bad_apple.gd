extends EffectItem

func _on_used() -> void:
	max_health_effect = -PlayerProperties.max_health
	super._on_used()
