extends Resource
class_name Item

signal used

## Имя предмета
@export var name: String
## Описание предмета
@export_multiline var description: String
## Является ли предмет используемым
@export var usable: bool = true
## Бесконечен ли предмет
@export var is_infinite: bool = false
## Изображение, которое будет отображаться как иконка
@export var image: Texture2D

func _init() -> void:
	used.connect(_on_used)

func use():
	if usable:
		used.emit()
		
func _on_used():
	pass

func get_item_name() -> String:
	return name

func get_description() -> String:
	return description

func get_usable() -> bool:
	return usable

func get_is_infinite() -> bool:
	return is_infinite

func get_image() -> Texture2D:
	return image
