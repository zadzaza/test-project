extends CharacterBody2D
class_name Player

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_label: Label = $HUD/GameStats/VBoxContainer/HBoxContainer/HealthLabel
@onready var keys_label: Label = $HUD/GameStats/VBoxContainer/HBoxContainer2/KeysLabel
@onready var player_inventory: PlayerInventory = $HUD/PlayerInventory
@onready var hud: CanvasLayer = $HUD

@export_enum("idle_side", "idle_up", "idle_down") var animation: String = "idle_down"

var is_dead: bool = false

var max_health: int = 10:
	set(new_value):
		max_health = new_value
		update_health_label(health, max_health)

var health: int = max_health:
	set(new_value):
		health = new_value
		if health == 0:
			die()
		update_health_label(health, max_health)
			
var keys: int = 0:
	set(new_value):
		keys = new_value
		update_keys_label(keys)

const SPEED = 70

var direction: Vector2
var last_direction: Vector2
var lock_control: bool

func _ready() -> void:
	update_health_label(PlayerProperties.health, PlayerProperties.max_health)
	update_keys_label(PlayerProperties.keys)
	player_inventory.item_dropped.connect(_on_item_dropped)
	hud.inventory_visible_changed.connect(func(is_visible: bool): lock_control = is_visible)
	GameEvent.player_position_changed.connect(_on_player_position_changed)
	#GameEvent.game_reloaded.connect(die)
	PlayerProperties.property_changed.connect(func(property: String, new_value: int): set_property(property, new_value))

func die():
	velocity = Vector2.ZERO
	animation = "death"
	hud.hide_inv()
	animated_sprite.play(animation)
	is_dead = true
	await get_tree().create_timer(1.5).timeout
	GameEvent.reload_game()

func set_property(property: String, new_value: int):
	set(property, new_value)

func update_health_label(health: int = 0, max_health: int = 0):
	health_label.text = str(health) + "/" + str(max_health)

func update_keys_label(keys: int):
	keys_label.text = str(keys)

func has_hey() -> bool:
	return keys > 0

func _on_player_position_changed(pos: Vector2):
	global_position = pos
	set_anim(Vector2(last_direction.x, -last_direction.y))

func set_anim(direction: Vector2):
	if direction.x != 0:
		animation = "run_side"
	if direction.y > 0:
		animation = "run_down"
	elif direction.y < 0:
		animation = "run_up"
	
	if animation == "run_side":
		if direction.x < 0:
			animated_sprite.flip_h = true
		elif direction.x > 0:
			animated_sprite.flip_h = false
				
	animated_sprite.play(animation)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("inventory") and not is_dead:
		hud.show_inv()


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if lock_control:
		stop()
		return
	
	var direction := Input.get_vector("left", "right", "up", "down")
	
	if direction:
		velocity = direction * SPEED
		last_direction = direction
		set_anim(direction)
	else:
		stop()
			
	move_and_slide()

func stop():
	velocity = Vector2.ZERO
	if animation == "run_side":
		animation = "idle_side"
	elif animation == "run_down":
		animation = "idle_down"
	elif animation == "run_up":
		animation = "idle_up"
	
	animated_sprite.play(animation)

func is_facing_target(target: Node2D) -> bool: # Проверяем, смотрит ли игрок в сторону предмета
	var to_target = (target.global_position - global_position).normalized()
	return last_direction.dot(to_target) > 0

func _on_item_pick_area_body_entered(interact_item: InteractItem) -> void:
	if interact_item.after_drop:
		return
	
	if interact_item is InteractKey:
		PlayerProperties.keys += 1
		interact_item.queue_free()
		return
	
	if player_inventory.add_item(interact_item.item):
		interact_item.queue_free()
		

func _on_item_pick_area_body_exited(interact_item: InteractItem) -> void:
	interact_item.after_drop = false

func _on_item_dropped(item: Item):
	var interact_item = load("uid://c7b5r7iomkqwi").instantiate()
	var ysort = get_tree().get_first_node_in_group("ysort")
	interact_item.item = item
	interact_item.after_drop = true
	ysort.add_child(interact_item)
	interact_item.owner = get_tree().current_scene
	interact_item.global_position = global_position + Vector2.DOWN*6
	
	
