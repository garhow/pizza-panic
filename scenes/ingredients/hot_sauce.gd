extends XRToolsPickable

func _ready() -> void:
	action_pressed.connect(_squeeze_bottle)

func _squeeze_bottle(_pickable) -> void:
	_play_sound()

func _play_sound() -> void:
	$Audio.stream = load("res://sound/ingredients/sauce/squeeze%s.ogg" % randi_range(1,4))
	$Audio.play()
	$Particles.emitting = true
	if $RayCast.is_colliding() and $RayCast.get_collider() is PizzaArea:
			$RayCast.get_collider().add_topping(Ingredient.Sauce.HOT)
