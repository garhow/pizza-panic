extends Control

func _start_arcade() -> void:
	Game.change_scene.emit(load("res://scenes/gamemodes/arcade.tscn"))


func _start_endless() -> void:
	Game.change_scene.emit(load("res://scenes/gamemodes/endless.tscn"))
