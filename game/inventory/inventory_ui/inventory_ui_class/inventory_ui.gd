extends Control
class_name InventoryUI

signal selected_item_changed(selected_item_index)

@export var item_collection: ItemCollection
@onready var h_flow_container: HFlowContainer = $VBoxContainer/HFlowContainer

var selected_item_index: int
var ui_slots: Array

func _ready() -> void:
	if item_collection:
		item_collection.setup()
		item_collection.updated.connect(_on_collection_updated)
		var collection = item_collection.get_collection()
		if collection:
			for s in collection:
				var slot_ui = load("uid://ifske7hil4j").instantiate()
				h_flow_container.add_child(slot_ui)
				if s.item:
					slot_ui.put_slot(s.item)
				slot_ui.selected.connect(_on_slot_selected)
		ui_slots = h_flow_container.get_children()

func use_item(slot_index: int) -> Item:
	return item_collection.use_item(slot_index)

func add_item(item: Item) -> bool:
	return item_collection.add_item(item)

func remove_item(slot_index: int) -> Item:
	return item_collection.remove_item(slot_index)

func is_any_selected():
	for s in h_flow_container.get_children():
		if s.is_selected:
			return true
	return false

func is_slot_empty(selected_item_index: int) -> bool:
	return ui_slots[selected_item_index].is_empty()

func _on_slot_selected(slot_ui: SlotUI = null):
	selected_item_index = slot_ui.get_index()
	selected_item_changed.emit(selected_item_index)
	for s in ui_slots:
		if s.is_selected:
			if s != slot_ui:
				s.select(false)

func _on_collection_updated(collection: Array[Slot]):
	var a = 0
	for i in range(len(collection)):
		if collection[i].item:
			ui_slots[i].put_slot(collection[i].item)
		else:
			ui_slots[i].remove_slot()
	
