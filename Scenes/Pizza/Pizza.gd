class_name Pizza extends PathFollow3D

signal ingredients_modified

@export var area: Area3D

var sauce := Ingredient.Sauce.NONE: set = _set_sauce
var cheese := false
var pepperoni: int = 0
var shrimp: int = 0
var pineapple: int = 0

func _ready():
	area.body_entered.connect(_on_body_entered)
	$"Tomato Sauce".visible = false
	$"Hot Sauce".visible = false
	$Cheese.visible = false


func _set_sauce(value: Ingredient.Sauce):
	sauce = value
	match value:
		Ingredient.Sauce.TOMATO:
			$"Tomato Sauce".visible = true
			$"Hot Sauce".visible = false
		Ingredient.Sauce.HOT:
			$"Tomato Sauce".visible = false
			$"Hot Sauce".visible = true
	emit_signal("ingredients_modified")

func add_topping(type: Ingredient.Topping) -> void:
	match type:
		Ingredient.Topping.CHEESE:
			cheese = true
			$Cheese.visible = true
		Ingredient.Topping.PEPPERONI:
			if pepperoni < 5:
				pepperoni += 1
				get_node("Pepperoni/" + str(pepperoni)).visible = true
		Ingredient.Topping.SHRIMP:
			if shrimp < 5:
				shrimp += 1
				get_node("Shrimp/" + str(shrimp)).visible = true
		Ingredient.Topping.PINEAPPLE:
			if pineapple < 5:
				pineapple += 1
				get_node("Pineapple/" + str(pineapple)).visible = true
	emit_signal("ingredients_modified")


func _on_body_entered(body):
	if body is Ingredient:
		body.vanish()
		add_topping(body.type)
