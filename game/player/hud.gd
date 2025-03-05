extends CanvasLayer

signal inventory_visible_changed(is_visible: bool)

@onready var game_stats: MarginContainer = $GameStats
@onready var player_inventory: PlayerInventory = $PlayerInventory

func show_inv():
	player_inventory.visible = not player_inventory.visible
	game_stats.visible = not player_inventory.visible
	
	inventory_visible_changed.emit(player_inventory.visible)

func hide_inv():
	player_inventory.visible = not player_inventory.visible
	game_stats.visible = not player_inventory.visible

func _ready() -> void:
	player_inventory.hide()
