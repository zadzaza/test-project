extends TextureRect
class_name SlotUI

signal selected(slot_ui: SlotUI)

@export var slot: Slot = Slot.new()
@onready var texture_rect: TextureRect = $TextureRect

var is_selected: bool = false

func _ready() -> void:
	slot.puted.connect(func(item): set_icon(item.get_image()))

func set_icon(icon: Texture2D):
	texture_rect.texture = icon

func put_slot(item: Item):
	slot.put(item)

func remove_slot():
	slot.remove()
	
	set_icon(null)
	select(false)

func select(is_select: bool):
	is_selected = is_select
	if is_select:
		self_modulate = Color(0.5, 0.5, 0.5)
		selected.emit(self)
	else:
		self_modulate = Color.WHITE
	
func is_empty():
	return slot == null

func _on_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		if not slot.is_empty():
			select(true)
