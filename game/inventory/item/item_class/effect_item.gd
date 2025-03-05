extends Item
class_name EffectItem

@export var health_effect: int = 0
@export var max_health_effect: int = 0

func _on_used():
	PlayerProperties.max_health += max_health_effect
	PlayerProperties.health += health_effect
	
