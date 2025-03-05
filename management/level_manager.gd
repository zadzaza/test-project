extends Node

var last_position: Vector2
var saved_scenes: Dictionary

func _ready() -> void:
	GameEvent.game_reloaded.connect(_on_game_reloaded)

func change_location(location: PackedScene, last_position: Vector2):
	GameEvent.player_position_changed.emit(last_position)
	
	var new_scene = location.instantiate()
	var current_scene = get_tree().current_scene
	
	saved_scenes[current_scene.name] = create_package(current_scene)
	current_scene.queue_free()
	
	if saved_scenes.has(new_scene.name):
		call_deferred("add_new_scene", saved_scenes[new_scene.name].instantiate(), last_position)
		new_scene.queue_free()
	else:
		call_deferred("add_new_scene", new_scene, last_position)

func _on_game_reloaded():
	saved_scenes = {}

func add_new_scene(new_scene, last_position):
	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene
	GameEvent.location_changed.emit(new_scene)


func create_package(node: Node) -> PackedScene:
	var package = PackedScene.new()
	
	package.pack(node)
	return package

func _set_owner(node: Node, _owner: Node):
	for child in node.get_children():
		child.owner = _owner
		_set_owner(child, _owner)
