extends Node2D
class_name House

@export var interior: PackedScene
@export var is_open: bool

@onready var confirm: VBoxContainer = $CanvasLayer/Confirm
@onready var door_anim: AnimatedSprite2D = $Building/Door/AnimatedSprite2D
@onready var spawn: Marker2D = $Building/Door/Spawn
@onready var enter_area: Area2D = $Building/Door/EnterArea
@onready var open_area: Area2D = $Building/Door/OpenArea

func _ready() -> void:
	confirm.hide()
	GameEvent.alarm_activated.connect(_on_alarm_activated)

func _on_alarm_activated():
	is_open = false
	door_anim.play("close")
	
	if open_area.has_overlapping_bodies():
		open_door()

func _on_open_area_body_entered(player: Player) -> void:
	open_door()

func open_door():
	if not interior:
		return
	
	if not is_open:
		if PlayerProperties.has_hey():
			confirm.show()
	
	if is_open:
		door_anim.play("open")
		
		
func _on_open_area_body_exited(player: Player) -> void:
	door_anim.play("close")
	confirm.hide()

func _on_enter_area_body_entered(player: Player) -> void:
	if not interior:
		return

	if is_open:
		LevelManager.change_location(interior, spawn.global_position)

func _on_yes_btn_pressed() -> void:
	is_open = true
	PlayerProperties.keys -= 1
	confirm.hide()
	door_anim.play("open")
	if enter_area.has_overlapping_bodies():
		LevelManager.change_location(interior, spawn.global_position)

func _on_no_btn_pressed() -> void:
	confirm.hide()
