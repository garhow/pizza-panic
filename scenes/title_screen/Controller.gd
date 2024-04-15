extends XRController3D

func _ready() -> void:
	connect("button_pressed", _start_game)

func _start_game(_name: String) -> void:
	Game.emit_signal("change_scene", load("res://scenes/kitchen/kitchen.tscn"))
