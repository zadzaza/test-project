extends InteractBody
class_name InteractItem

@export var item: Item

# Используем TextureRect, чтобы корректировать размер изображений под нужный
# Пришлось так сделать из-за разного размера ассетов
@onready var texture: TextureRect = $TextureRect

var after_drop = false

func _ready() -> void:
	item.used.connect(_on_used)
	var item_image = item.get_image()
	if item_image:
		texture.texture = item_image

func use_item():
	item.use()

func _on_used():
	pass
