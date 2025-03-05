extends Resource
class_name Slot

signal ended(slot: Slot)
signal puted(item: Item)
signal removed

@export var item: Item

func put(item: Item):
	self.item = item
	puted.emit(item)

func remove():
	self.item = null

func get_slot() -> Slot:
	return self

func is_empty() -> bool:
	return item == null
