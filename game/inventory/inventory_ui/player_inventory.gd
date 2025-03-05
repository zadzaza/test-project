extends InventoryUI
class_name PlayerInventory

signal item_dropped(item: Item)

@onready var name_lbl: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Panel/MarginContainer/NameLbl
@onready var description_lbl: Label = $VBoxContainer/HBoxContainer/VBoxContainer/Panel2/MarginContainer/DescriptionLbl
@onready var use_btn: Button = $VBoxContainer/HBoxContainer/Panel2/VBoxContainer/UseBtn
@onready var remove_btn: Button = $VBoxContainer/HBoxContainer/Panel2/VBoxContainer/RemoveBtn

func _ready() -> void:
	super._ready()
	selected_item_changed.connect(_on_selected_item_changed)
	
	use_btn.disabled = true
	remove_btn.disabled = true
	GameEvent.game_reloaded.connect(reset_inv)

func reset_inv():
	item_collection.reset()

func refresh_btns():
	use_btn.disabled = not is_any_selected() or not item_collection.get_item_usable(selected_item_index)
	remove_btn.disabled = not is_any_selected()
	

func refresh_control():
	name_lbl.text = item_collection.get_item_name(selected_item_index)
	description_lbl.text = item_collection.get_item_description(selected_item_index)
	refresh_btns()

func _on_selected_item_changed(selected_item_index: int):
	refresh_control()

func _on_use_btn_pressed() -> void:
	use_item(selected_item_index)
	refresh_control()
	
func _on_remove_btn_pressed() -> void:
	var dropped_item = remove_item(selected_item_index)
	if dropped_item:
		item_dropped.emit(dropped_item)
	refresh_control()
