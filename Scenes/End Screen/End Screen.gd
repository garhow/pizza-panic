extends Node3D

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	Game.emit_signal("change_scene", load("res://Scenes/Title Screen/Title Screen.tscn"))
