extends Resource
class_name ItemCollection

signal updated(collection: Array[Slot])

@export var collection: Array[Slot]

func setup() -> void:
	for i in range(collection.size()):
		if collection[i] == null:
			collection[i] = Slot.new()

func reset():
	for i in range(collection.size()):
		collection[i] = Slot.new()
	updated.emit()

func use_item(slot_index: int) -> Item:
	var item = collection[slot_index].item
	if item.is_infinite:
		item.use()
		return null
	item.use()
	return remove_item(slot_index)

func add_item(item: Item) -> bool:
	for s in collection:
		if s.is_empty():
			s.put(item)
			#s.ended.connect(_on_slot_item_ended)
			updated.emit(collection)
			return true
	
	return false
	
func remove_item(slot_index: int) -> Item:
	if slot_index < 0 or slot_index >= collection.size():
		return null
	
	var removed_item = collection[slot_index].item
	collection[slot_index].remove()
	
	for i in range(slot_index, collection.size() - 1):
		var next_slot = collection[i + 1]
		if next_slot.item:
			collection[i].put(next_slot.item)
			next_slot.remove()
		
	collection[collection.size() - 1].remove()
	
	updated.emit(collection)
	
	return removed_item
	
func get_collection() -> Array[Slot]:
	return collection

func get_item_name(slot_index: int) -> String:
	var item = collection[slot_index].item
	if not item:
		return "Название"
	
	return item.get_item_name()

func get_item_description(slot_index: int) -> String:
	var item = collection[slot_index].item
	if not item:
		return "Описание"
	
	return item.get_description()

func get_item_usable(slot_index: int) -> bool:
	if collection[slot_index].item:
		return collection[slot_index].item.get_usable()
	return false

#func _on_slot_item_ended(slot: Slot):
	#for i in range(collection.size()):
		#if collection[i] == slot:
			#remove_item(i)
