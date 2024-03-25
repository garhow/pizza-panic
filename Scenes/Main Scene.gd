extends Node3D

var current_scene: Node

@export var developer_mode: bool = false

func _ready():
	Game.connect("change_scene", _change_scene)
	match developer_mode:
		false: Game.emit_signal("change_scene", load("res://Scenes/Title Screen/Title Screen.tscn"))
		true: Game.emit_signal("change_scene", load("res://Scenes/Kitchen/Kitchen.tscn"))

func _change_scene(scene: PackedScene):
	if current_scene: current_scene.queue_free()
	var new_scene = scene.instantiate()
	add_child(new_scene)
	current_scene = new_scene
