class_name Ingredient extends XRToolsPickable

enum Topping {
	NONE,
	TOMATO_SAUCE,
	HOT_SAUCE,
	CHEESE,
	PEPPERONI,
	SHRIMP,
	PINEAPPLE,
}

enum Sauce {
	NONE,
	TOMATO,
	HOT
}

@export var type: Topping

@onready var collision: CollisionShape3D = find_children("*", "CollisionShape3D")[0]
@onready var mesh: MeshInstance3D = find_children("*", "MeshInstance3D")[0]

func vanish() -> void:
	sleeping = true
	freeze = true
	collision.set_deferred("disabled", "true")
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(mesh, "scale", Vector3.ZERO, 0.1)
	tween.tween_callback(queue_free)
	
	
	
	
	
