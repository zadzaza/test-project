extends InteractBody
class_name InteractObject

@export_multiline var interact_text: Array[String]
@export var outline_color: Color = Color.WHITE

@onready var outline_shader: Shader = preload("res://res/outline.gdshader")
@onready var message: MarginContainer = $CanvasLayer/Message
@onready var message_text: Label = $CanvasLayer/Message/MarginContainer/Label
@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D

var interact_count: int
var player: Player

func _ready() -> void:
	message.hide()
	hide_outline()
	init_shader()

func _process(delta: float) -> void:
	if in_interact_area:
		if player.is_facing_target(self):
			show_outline()
			if Input.is_action_just_pressed("interact"):
				interact()
		else:
			hide_outline()


func init_shader():
	var shader_material = ShaderMaterial.new()
	shader_material.shader = outline_shader
	sprite.material = shader_material
	sprite.material.set_shader_parameter("color", outline_color)

func show_outline():
	if not sprite.material:
		init_shader()
	
	if interact_text.is_empty():
		hide_outline()
		return
	
	sprite.material.set_shader_parameter("top", true)
	sprite.material.set_shader_parameter("left", true)
	sprite.material.set_shader_parameter("right", true)
	sprite.material.set_shader_parameter("bottom", true)

func hide_outline():
	sprite.material.set_shader_parameter("top", false)
	sprite.material.set_shader_parameter("left", false)
	sprite.material.set_shader_parameter("right", false)
	sprite.material.set_shader_parameter("bottom", false)

func interact(player: Player = null):
	show_message()
	timer.start()
	
func _on_interact_area_body_entered(player: Player) -> void:
	self.player = player

func _on_interact_area_body_exited(player: Player) -> void:
	player = null
	hide_message()

func _on_timer_timeout() -> void:
	hide_message()

func show_message():
	if interact_text.size() > 0:
		update_text()
		message.show()
	
func hide_message():
	message.hide()
	interact_count = 0

func update_text():
	message_text.text = interact_text[interact_count % interact_text.size()]
	interact_count += 1
