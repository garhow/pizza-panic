class_name PizzaArea extends Area3D

@onready var pizza: Pizza = get_parent()

func add_topping(type: Ingredient.Topping) -> void:
	match type:
		Ingredient.Topping.TOMATO_SAUCE: pizza.sauce = Ingredient.Sauce.TOMATO
		Ingredient.Topping.HOT_SAUCE: pizza.sauce = Ingredient.Sauce.HOT
		_: pizza.add_topping(type)
