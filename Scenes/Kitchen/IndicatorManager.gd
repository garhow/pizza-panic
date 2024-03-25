class_name IndicatorManager extends Node3D

func _ready():
	invisiblify()

func invisiblify() -> void:
	for node in get_children(): node.visible = false

func visiblify(indicator: Ingredient.Topping) -> void:
	invisiblify()
	match indicator:
		Ingredient.Topping.TOMATO_SAUCE: $"Tomato Sauce".visible = true
		Ingredient.Topping.HOT_SAUCE: $"Hot Sauce".visible = true
		Ingredient.Topping.CHEESE: $Cheese.visible = true
		Ingredient.Topping.PEPPERONI: $Pepperoni.visible = true
		Ingredient.Topping.SHRIMP: $Shrimp.visible = true
		Ingredient.Topping.PINEAPPLE: $Pineapple.visible = true
