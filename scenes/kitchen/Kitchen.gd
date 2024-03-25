extends Node3D

class Stats:
	var amount: int
	var mistakes: int = 0
	var remaining: int
	
	func _init(count: int):
		amount = count
		remaining = count

const pizza_scene = preload("res://scenes/pizza/pizza.tscn")

const FINISHED_SPEED = 0.010
const SPEED_INCREMENT = 0.00005

class Recipe:
	var sauce: Ingredient.Sauce
	var cheese: bool
	var pepperoni: int
	var shrimp: int
	var pineapple: int

@export var recipe_label: Label3D

@export var stats_label: Label3D

@export var path: Path3D

@export var audio_correct: AudioStreamPlayer
@export var audio_incorrect: AudioStreamPlayer

## Game stats
@onready var stats = Stats.new(40)

var recipe: Recipe: set = _set_recipe

var completed := false
var speed := 0.0005

var pizza: Pizza
var current_speed

func _ready() -> void:
	_generate_recipe()
	_spawn_pizza()
	_update_stats()

func _physics_process(delta: float) -> void:
	if pizza:
		current_speed = speed if not completed else lerp(current_speed, FINISHED_SPEED, delta)
		pizza.progress_ratio += current_speed
		if pizza.progress_ratio >= 1:
			_check_finished_pizza()

func _generate_recipe() -> void:
	var new_recipe = Recipe.new()
	
	## Sauce
	new_recipe.sauce = Ingredient.Sauce.TOMATO if randi_range(0, 1) else Ingredient.Sauce.HOT
	
	## Cheese
	new_recipe.cheese = true
	
	## Pepperoni / Shrimp / Pineapple
	match randi_range(0, 6):
		3: new_recipe.pepperoni = 5
		4: new_recipe.shrimp = 5
		5: new_recipe.pineapple = 5
		6:
			new_recipe.pepperoni = 1
			new_recipe.shrimp = 1
			new_recipe.pineapple = 1
	
	## Apply recipe
	recipe = new_recipe

func _spawn_pizza() -> void:
	if pizza:
		if pizza.ingredients_modified.is_connected(_check_unfinished_pizza):
			pizza.ingredients_modified.disconnect(_check_unfinished_pizza)
		pizza.queue_free()
	var new_pizza = pizza_scene.instantiate()
	path.add_child(new_pizza)
	pizza = new_pizza
	new_pizza.ingredients_modified.connect(_check_unfinished_pizza)

func _check_pizza() -> bool:
	if (pizza.sauce == recipe.sauce
	and pizza.cheese == recipe.cheese
	and pizza.pepperoni == recipe.pepperoni
	and pizza.shrimp == recipe.shrimp
	and pizza.pineapple == recipe.pineapple):
		return true
	else:
		return false

func _check_unfinished_pizza() -> void:
	if _check_pizza():
		completed = true

func _check_finished_pizza() -> void:
	if completed:
		stats.remaining -= 1
		speed += SPEED_INCREMENT
		_generate_recipe()
		_spawn_pizza()
		audio_correct.play()
	else:
		stats.mistakes += 1
		speed -= SPEED_INCREMENT
		_spawn_pizza()
		audio_incorrect.play()
	completed = false
	_update_stats()

func _update_stats() -> void:
	stats_label.text = "Pizzas Made: %s\nPizzas Left: %s\nMistakes: %s" % [stats.amount - stats.remaining, stats.remaining, stats.mistakes]
	if stats.remaining == 0:
		Game.emit_signal("change_scene", load("res://scenes/end_screen/victory.tscn"))
	if stats.mistakes >= 3:
		Game.emit_signal("change_scene", load("res://scenes/end_screen/failure.tscn"))

func _set_recipe(value: Recipe):
	recipe = value
	
	var string := ""
	
	match value.sauce:
		Ingredient.Sauce.TOMATO: string += "Tomato sauce\n"
		Ingredient.Sauce.HOT: string += "Hot sauce\n"
		
	if value.cheese: string += "Cheese\n"
	
	if value.pepperoni: string += "%s Pepperoni\n" % str(value.pepperoni)
	if value.shrimp: string += "%s Shrimp\n" % str(value.shrimp)
	if value.pineapple: string += "%s Pineapple\n" % str(value.pineapple)
	
	recipe_label.text = string
